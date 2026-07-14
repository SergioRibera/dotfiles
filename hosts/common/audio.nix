{
  lib,
  config,
  inputs,
  ...
}:
let
  # Browse available presets after 'nix flake lock':
  #   ls $(nix eval --raw .#inputs.hrtf-files)/hrir/
  # Common choices: "Dolby Atmos for Headphones HeSuVi 2.0.wav",
  #                 "Windows Sonic for Headphones.wav", "DTS Headphone X.wav"
  hrirFile = "${inputs.hrtf-files}/hrir/Dolby Atmos for Headphones HeSuVi 2.0.wav";

  mkCopy = name: { type = "builtin"; inherit name; label = "copy"; };
  mkConv = name: ch: {
    type = "builtin";
    inherit name;
    label = "convolver";
    config = { filename = hrirFile; channel = ch; };
  };
  lnk = output: input: { inherit output input; };
in
{
  services.pipewire.extraConfig.pipewire."99-virtual-surround" = lib.mkIf config.audio {
    "context.modules" = [
      {
        name = "libpipewire-module-filter-chain";
        flags = [ "nofail" ];
        args = {
          "node.description" = "Virtual Surround Sink";
          "media.name" = "Virtual Surround Sink";

          "filter.graph" = {
            nodes = [
              # copy nodes: fan each mono input out to two convolvers
              (mkCopy "copyFL")  (mkCopy "copyFR")  (mkCopy "copyFC")
              (mkCopy "copyLFE") (mkCopy "copyRL")  (mkCopy "copyRR")
              (mkCopy "copySL")  (mkCopy "copySR")

              # HeSuVi 14-channel channel order:
              #   0 FL_L  1 FL_R  2 SL_L  3 SL_R  4 RL_L  5 RL_R
              #   6 FC_L  7 FR_R  8 FR_L  9 SR_R 10 SR_L 11 RR_R
              #  12 RR_L 13 FC_R
              (mkConv "convFL_L"   0) (mkConv "convFL_R"   1)
              (mkConv "convSL_L"   2) (mkConv "convSL_R"   3)
              (mkConv "convRL_L"   4) (mkConv "convRL_R"   5)
              (mkConv "convFC_L"   6) (mkConv "convFR_R"   7)
              (mkConv "convFR_L"   8) (mkConv "convSR_R"   9)
              (mkConv "convSR_L"  10) (mkConv "convRR_R"  11)
              (mkConv "convRR_L"  12) (mkConv "convFC_R"  13)
              # LFE has no dedicated HRIR — treat as FC (center, non-directional)
              (mkConv "convLFE_L"  6) (mkConv "convLFE_R" 13)

              # stereo output
              { type = "builtin"; name = "mixL"; label = "mixer"; }
              { type = "builtin"; name = "mixR"; label = "mixer"; }
            ];

            links = [
              # fanout: copy:Out → both L and R convolvers for each direction
              (lnk "copyFL:Out"  "convFL_L:In")  (lnk "copyFL:Out"  "convFL_R:In")
              (lnk "copySL:Out"  "convSL_L:In")  (lnk "copySL:Out"  "convSL_R:In")
              (lnk "copyRL:Out"  "convRL_L:In")  (lnk "copyRL:Out"  "convRL_R:In")
              (lnk "copyFC:Out"  "convFC_L:In")  (lnk "copyFC:Out"  "convFC_R:In")
              (lnk "copyFR:Out"  "convFR_L:In")  (lnk "copyFR:Out"  "convFR_R:In")
              (lnk "copySR:Out"  "convSR_L:In")  (lnk "copySR:Out"  "convSR_R:In")
              (lnk "copyRR:Out"  "convRR_L:In")  (lnk "copyRR:Out"  "convRR_R:In")
              (lnk "copyLFE:Out" "convLFE_L:In") (lnk "copyLFE:Out" "convLFE_R:In")

              # mix all L/R contributions to stereo output
              (lnk "convFL_L:Out"  "mixL:In 1") (lnk "convFL_R:Out"  "mixR:In 1")
              (lnk "convSL_L:Out"  "mixL:In 2") (lnk "convSL_R:Out"  "mixR:In 2")
              (lnk "convRL_L:Out"  "mixL:In 3") (lnk "convRL_R:Out"  "mixR:In 3")
              (lnk "convFC_L:Out"  "mixL:In 4") (lnk "convFC_R:Out"  "mixR:In 4")
              (lnk "convFR_L:Out"  "mixL:In 5") (lnk "convFR_R:Out"  "mixR:In 5")
              (lnk "convSR_L:Out"  "mixL:In 6") (lnk "convSR_R:Out"  "mixR:In 6")
              (lnk "convRR_L:Out"  "mixL:In 7") (lnk "convRR_R:Out"  "mixR:In 7")
              (lnk "convLFE_L:Out" "mixL:In 8") (lnk "convLFE_R:Out" "mixR:In 8")
            ];

            inputs  = [ "copyFL:In" "copyFR:In" "copyFC:In" "copyLFE:In"
                        "copyRL:In" "copyRR:In" "copySL:In" "copySR:In" ];
            outputs = [ "mixL:Out" "mixR:Out" ];
          };

          # Exposed as a 7.1 sink — apps/games/upmixers connect here
          "capture.props" = {
            "node.name"      = "effect_input.virtual-surround-7.1-hesuvi";
            "media.class"    = "Audio/Sink";
            "audio.channels" = 8;
            "audio.position" = [ "FL" "FR" "FC" "LFE" "RL" "RR" "SL" "SR" ];
          };

          # Routes passively to whatever default sink is active (BT/USB/HDMI)
          "playback.props" = {
            "node.name"      = "effect_output.virtual-surround-7.1-hesuvi";
            "node.passive"   = true;
            "audio.channels" = 2;
            "audio.position" = [ "FL" "FR" ];
          };
        };
      }
    ];
  };
}
