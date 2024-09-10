{ pkgs, lib, config, ... }: {
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  security.pam.services.login.enableGnomeKeyring = true;
  # security.pam.services.greetd.enableGnomeKeyring = true;

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

    pipewire = lib.mkIf config.audio {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    xserver = {
      xkb.layout = "us";
      xkb.variant = "altgr-intl";
      videoDrivers = lib.optionals config.gui.enable [ "amdgpu" ];
    };

    greetd = lib.mkIf (pkgs.stdenv.buildPlatform.isLinux && config.gui.enable) {
      enable = true;
      restart = false;

      settings = let
        session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd niri-session";
          # command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
          user = config.user.username;
        };
      in {
        default_session = session;
        initial_session = session;
      };
    };
  };
}
