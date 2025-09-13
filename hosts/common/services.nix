{ inputs, pkgs, lib, config, ... }: let
  sosdEnabled = config.user.enableHM && config.home-manager.users.${config.user.username}.programs.sosd.enable;

  isWmEnable = name: builtins.elem name config.wm.actives;
in
with pkgs.stdenv.buildPlatform;
{
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  security.polkit.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
  environment.systemPackages = with pkgs; [ catppuccin-sddm ];

  systemd.network.wait-online.enable = !config.gui.enable;
  systemd.user.services.mpris-proxy = lib.mkIf (isLinux && config.bluetooth) {
      description = "Mpris proxy";
      after = [ "network.target" "sound.target" ];
      wantedBy = [ "default.target" ];
      serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
  };

  services = {
    udisks2.enable = true;
    upower = {
      enable = true;
      percentageLow = 30;
      percentageCritical = 15;
    };
    ratbagd.enable = true;
    gnome.gnome-keyring.enable = (isLinux && config.gui.enable);
    udev.packages = lib.optionals (isLinux && config.gui.enable && !sosdEnabled) [ pkgs.swayosd ];
    dbus = {
      enable = true;
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
      pulse.enable = true;
      wireplumber.enable = true;
    };

    displayManager = {
      gdm.enable = config.gui.enable;
      sessionPackages = builtins.map (o: pkgs."${o}") (builtins.filter (o: builtins.hasAttr o pkgs && o != "jay") config.wm.actives)
        ++ (lib.optionals (isWmEnable "mango") [config.programs.mango.package]);
      autoLogin = {
        enable = !config.gui.enable;
        user = config.user.username;
      };
    };

    xserver = lib.mkIf isLinux {
      xkb.layout = "us";
      xkb.variant = "altgr-intl";
    };
  };
}
