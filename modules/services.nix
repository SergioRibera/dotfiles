{ pkgs, config, ... }: {
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
  security.pam.services.login.enableGnomeKeyring = true;

  services = {
    upower.enable = true;
    ratbagd.enable = true;
    gnome.gnome-keyring.enable = true;
    dbus.packages = [ pkgs.gcr ];

    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = true;
      };
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
    xserver = {
      enable = true;
      layout = "us";
      videoDrivers = [ "amdgpu" ];
      excludePackages = [
        pkgs.xterm
      ];
      displayManager = {
        gdm.enable = true;
        autoLogin = {
          enable = true;
          user = config.laptop.username;
        };
      };
    };
  };
}
