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
    configFile."wired/wired.ron".text = lib.optionalString
      (pkgs.stdenv.buildPlatform.isLinux && gui.enable)
      (import ../desktop/wired.nix { colors = gui.theme.colors; });
  };

  xdg = lib.mkIf (pkgs.stdenv.buildPlatform.isLinux && gui.enable) {
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config = {
        common.default = [ "*" ];
        hyprland.default = [ "hyprland" ];
      };

      extraPortals = [
        pkgs.xdg-desktop-portal-hyprland
      ];
    };
  };
}
