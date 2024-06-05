{ pkgs, lib, config, ... }: {
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  security.pam.services.login.enableGnomeKeyring = true;

  services = {
    udisks2.enable = true;
    upower = {
      enable = true;
      percentageLow = 30;
      percentageCritical = 15;
    };
    ratbagd.enable = true;
    dbus.packages = [ pkgs.gcr ];
    gnome.gnome-keyring.enable = true;
    udev.packages = lib.optionals (pkgs.stdenv.buildPlatform.isLinux && config.gui.enable) [ pkgs.swayosd ];

    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = true;
        PermitRootLogin = "no";
      };
    };

    pipewire = lib.mkIf config.gui.enable {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    xserver = {
      xkb.layout = "us";
      videoDrivers = lib.optionals config.gui.enable [ "amdgpu" ];
    };

    greetd = lib.mkIf (pkgs.stdenv.buildPlatform.isLinux && config.gui.enable) {
      enable = true;
      restart = false;

      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland --time-format '%F %R'";
          user = config.user.username;
        };
        initial_session = {
          command = "${pkgs.hyprland}/bin/Hyprland";
          user = config.user.username;
        };
        dwl = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd dwl --time-format '%F %R'";
          user = config.user.username;
        };
      };
    };
  };
}
