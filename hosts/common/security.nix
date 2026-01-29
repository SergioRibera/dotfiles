{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (config) gui;
  inherit (lib) getExe';
in
{
  security.polkit.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
  security.rtkit.enable = pkgs.stdenv.buildPlatform.isLinux && gui.enable;

  security.sudo.enable = false;
  security.sudo-rs = {
    enable = true;
    extraConfig = ''
      Defaults pwfeedback
      Defaults env_keep += "EDITOR PATH"
    '';
    extraRules = [
      {
        groups = [ "wheel" ];

        commands = [
          {
            command = getExe' pkgs.systemd "systemctl";
            options = [ "NOPASSWD" ];
          }
          {
            command = getExe' pkgs.systemd "reboot";
            options = [ "NOPASSWD" ];
          }
          {
            command = getExe' pkgs.systemd "shutdown";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };
}
