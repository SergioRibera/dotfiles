{ pkgs, ... }: {
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
  security.pam.services.login.enableGnomeKeyring = true;

  services = {
    upower.enable = true;
    ratbagd.enable = true;
    dbus.packages = [ pkgs.gcr ];

    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = true;
        PermitRootLogin = "no";
      };
    };

    xserver = {
      xkb.layout = "us";
    };
  };
}
