{ pkgs
    , self'
    , ...
}: {
    systemd.services."getty@tty1".enable = false;
    systemd.services."autovt@tty1".enable = false;

    services = {
        upower.enable = true;
        ratbagd.enable = true;
        gnome.gnome-keyring.enable = true;
        dbus.packages = [ pkgs.gcr ];

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
        };
        printing = {
            enable = true;
        };
        xserver = {
            enable = true;
            layout = "us";
            displayManager.gdm.enable = true;
        };
    };
}
