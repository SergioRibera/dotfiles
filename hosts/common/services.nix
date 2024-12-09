{ pkgs, lib, config, ... }: {
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  security.pam.services.login.enableGnomeKeyring = true;
  environment.systemPackages = with pkgs; [ catppuccin-sddm ];

  services = {
    # Enables the daemon for lorri, a nix-shell replacement for project development
    lorri.enable = true;
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

    xserver = lib.mkIf pkgs.stdenv.buildPlatform.isLinux {
      xkb.layout = "us";
      xkb.variant = "altgr-intl";
      videoDrivers = lib.optionals config.gui.enable [ "amdgpu" ];
    };

    displayManager = {
      sessionPackages = [ pkgs.niri ];
      sddm = lib.mkIf (pkgs.stdenv.buildPlatform.isLinux && config.gui.enable) {
        enable = true;
        theme = "catppuccin-mocha";
        wayland.enable = true;
        package = pkgs.kdePackages.sddm;
        settings = {
          Theme.CursorTheme = config.gui.cursor.name;
          Wayland.CursorTheme = config.gui.cursor.name;
        };
      };
    };
  };
}
