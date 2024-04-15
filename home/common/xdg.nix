{ pkgs, config, ... }:
let
  inherit (config) user;
in
{
  home-manager.users."${user.username}".xdg = {
    enable = user.enableGUI;
    userDirs = {
      enable = user.enableGUI;
      music = null;
      desktop = null;
      publicShare = null;
      createDirectories = user.enableGUI;
    };
  };
  xdg.portal = {
    enable = user.enableGUI;
    xdgOpenUsePortal = user.enableGUI;
    config = {
      common.default = [ "gtk" ];
      hyprland.default = [ "gtk" "hyprland" ];
    };

    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };
}
