{ pkgs, config, ... }:
let
  inherit (config) gui;
in
{
  security.polkit.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
  security.rtkit.enable = pkgs.stdenv.buildPlatform.isLinux && gui.enable;
}
