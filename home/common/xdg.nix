{ pkgs, config, lib, ... }:
let
  inherit (config) user gui;
in
{
  home-manager.users."${user.username}".xdg = lib.mkIf (pkgs.stdenv.buildPlatform.isLinux && gui.enable) {
    enable = true;
    userDirs = {
      enable = true;
      music = null;
      desktop = null;
      publicShare = null;
      createDirectories = true;
    };
  };
  xdg = lib.mkIf (pkgs.stdenv.buildPlatform.isLinux && gui.enable) {
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config = {
        # common.default = [ "gtk" ];
        hyprland.default = [ "hyprland" ];
      };

      extraPortals = [
        # pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-hyprland
      ];
    };
  };
}
