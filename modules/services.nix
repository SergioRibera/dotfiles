{ pkgs, config, ... }: {
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
  security.pam.services.login.enableGnomeKeyring = true;

  services = {
    upower.enable = true;
    ratbagd.enable = true;
    dbus.packages = [ pkgs.gcr ];
    gnome.gnome-keyring.enable = true;

    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = true;
        PermitRootLogin = "no";
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
      layout = "us";
      videoDrivers = [ "amdgpu" ];
    };
  };
}
