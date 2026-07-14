{
  lib,
  config,
  inputs,
  ...
}:
let
  # Stereo HRTF WAV files: channel 0 = left ear, channel 1 = right ear.
  # Each file encodes the impulse response for one surround direction.
  # SL/SR approximate with RL/RR — 6channel-hrir has no side-channel IRs.
  hrtf = inputs.hrtf-files;

  mkConv = name: file: {
    type = "builtin";
    inherit name;
    label = "convolver";
    config.filename = "${hrtf}/${file}";
  };

  mkLink = src: dst: {
    output = src;
    input = dst;
  };
in
{
  services.pipewire.extraConfig.pipewire."99-virtual-surround" = lib.mkIf config.audio {
    "context.modules" = [
      {
        name = "libpipewire-module-filter-chain";
        args = {
          "node.description" = "Virtual Surround 7.1";
          "media.name" = "Virtual Surround 7.1";

          "filter.graph" = {
            nodes = [
              # 8 stereo convolvers: mono in → stereo out (L-ear / R-ear HRTF per direction)
              (mkConv "convFL" "FL.wav")
              (mkConv "convFR" "FR.wav")
              (mkConv "convFC" "FC.wav")
              (mkConv "convLFE" "LFE.wav")
              (mkConv "convRL" "RL.wav")
              (mkConv "convRR" "RR.wav")
              (mkConv "convSL" "RL.wav") # side ≈ rear (no side IR available)
              (mkConv "convSR" "RR.wav")
              # Mixers: sum all L-ear contributions → L out, same for R
              { type = "builtin"; name = "mixer_L"; label = "mixer"; }
              { type = "builtin"; name = "mixer_R"; label = "mixer"; }
            ];

            links = [
              (mkLink "convFL:Out 1"  "mixer_L:In 1")
              (mkLink "convFL:Out 2"  "mixer_R:In 1")
              (mkLink "convFR:Out 1"  "mixer_L:In 2")
              (mkLink "convFR:Out 2"  "mixer_R:In 2")
              (mkLink "convFC:Out 1"  "mixer_L:In 3")
              (mkLink "convFC:Out 2"  "mixer_R:In 3")
              (mkLink "convLFE:Out 1" "mixer_L:In 4")
              (mkLink "convLFE:Out 2" "mixer_R:In 4")
              (mkLink "convRL:Out 1"  "mixer_L:In 5")
              (mkLink "convRL:Out 2"  "mixer_R:In 5")
              (mkLink "convRR:Out 1"  "mixer_L:In 6")
              (mkLink "convRR:Out 2"  "mixer_R:In 6")
              (mkLink "convSL:Out 1"  "mixer_L:In 7")
              (mkLink "convSL:Out 2"  "mixer_R:In 7")
              (mkLink "convSR:Out 1"  "mixer_L:In 8")
              (mkLink "convSR:Out 2"  "mixer_R:In 8")
            ];

            # Graph boundary: 8 capture channels → 8 convolver inputs
            inputs = [
              "convFL:In" "convFR:In" "convFC:In" "convLFE:In"
              "convRL:In" "convRR:In" "convSL:In" "convSR:In"
            ];
            # Stereo output → headphones/BT
            outputs = [ "mixer_L:Out" "mixer_R:Out" ];
          };

          # Appears as a 7.1 sink — apps/games output here
          "capture.props" = {
            "node.name" = "effect_input.virtual-surround-7.1";
            "media.class" = "Audio/Sink";
            "audio.channels" = 8;
            "audio.position" = [ "FL" "FR" "FC" "LFE" "RL" "RR" "SL" "SR" ];
          };

          # Routes to whatever sink is default (headphones, BT, etc.)
          "playback.props" = {
            "node.name" = "effect_output.virtual-surround-7.1";
            "node.passive" = true;
            "audio.channels" = 2;
            "audio.position" = [ "FL" "FR" ];
          };
        };
      }
    ];
  };
}
