{
  pkgs,
  lib,
  config,
  ...
}:
let
  isWmEnable = name: builtins.elem name config.wm.actives;
in
with pkgs.stdenv.buildPlatform;
{
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  environment.systemPackages = with pkgs; [ catppuccin-sddm ];

  systemd.network.wait-online.enable = !config.gui.enable;
  systemd.user.services.mpris-proxy = lib.mkIf (isLinux && config.bluetooth) {
    description = "Mpris proxy";
    after = [
      "network.target"
      "sound.target"
    ];
    wantedBy = [ "default.target" ];
    serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
  };

  services = {
    acpid.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
      };
    };
    udisks2.enable = true;
    upower = {
      enable = true;
      percentageLow = 30;
      percentageCritical = 15;
    };
    ratbagd.enable = true;
    fstrim.enable = true;
    journald.extraConfig = ''
      SystemMaxUse=500M
      RuntimeMaxUse=10M
    '';
    gnome.gnome-keyring.enable = (isLinux && config.gui.enable);
    dbus = {
      enable = true;
      implementation = "dbus";
      packages = [ pkgs.gcr ];
    };

    qemuGuest.enable = (isLinux && config.gui.enable);
    spice-vdagentd.enable = (isLinux && config.gui.enable);

    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = true;
        PermitRootLogin = "no";
      };
    };

    pipewire = lib.mkIf config.audio {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;

      extraConfig.pipewire."92-lowlatency" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 512;
          "default.clock.min-quantum" = 256;
          "default.clock.max-quantum" = 2048;
        };
      };

      wireplumber.extraConfig = {
        "51-bluetooth" = {
          "monitor.bluez.properties" = {
            "bluez5.enable-sbc-xq" = true;
            "bluez5.enable-msbc" = true;
            # LC3 = BT LE Audio (lowest latency ~20ms), then aptX-LL, then rest
            "bluez5.codecs" = [ "lc3" "ldac" "aptx_ll" "aptx_hd" "aptx" "aac" "sbc_xq" "sbc" ];
            # BAP roles enable BT LE Audio multi-channel (hardware permitting)
            "bluez5.roles" = [ "a2dp_sink" "a2dp_source" "bap_sink" "bap_source" "hfp_hf" "hfp_ag" ];
          };
        };
        # ACP enables full profile enumeration: detects 2.0/5.1/7.1 on HDMI/USB
        "52-alsa-acp" = {
          "monitor.alsa.rules" = [ {
            matches = [ { "device.name" = "~alsa_card.*"; } ];
            actions.update-props."api.alsa.use-acp" = true;
          } ];
        };
      };
    };

    displayManager = {
      gdm.enable = config.gui.enable;
      sessionPackages =
        map (o: pkgs."${o}") (
          builtins.filter (o: builtins.hasAttr o pkgs && o != "jay") config.wm.actives
        )
        ++ (lib.optionals (isWmEnable "mango") [ config.programs.mango.package ]);
      autoLogin = {
        enable = !config.gui.enable;
        user = config.user.username;
      };
    };

    xserver = lib.mkIf isLinux {
      xkb.layout = "us";
      xkb.variant = "altgr-intl";
    };

    udev.extraRules = lib.mkIf config.games ''
      SUBSYSTEM=="input", ATTRS{name}=="*Wireless Controller Touchpad*", ENV{ID_INPUT}="", ENV{ID_INPUT_TOUCHPAD}="", ENV{ID_INPUT_MOUSE}=""
    '';
  };

  hardware.steam-hardware.enable = lib.mkIf config.games true;

  environment.etc."openal/alsoft.conf" = lib.mkIf config.audio {
    text = ''
      [general]
      hrtf = true
      default-hrtf = Default HRTF
    '';
  };
}
