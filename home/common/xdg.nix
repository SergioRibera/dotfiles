{ pkgs, config, lib, ... }:
let
  inherit (config) user gui wm;
  sosdEnabled = config.home-manager.users.${user.username}.programs.sosd.enable;
in
{
  home-manager.users."${user.username}".xdg = lib.mkIf (pkgs.stdenv.buildPlatform.isLinux) {
    enable = true;
    userDirs = {
      enable = true;
      music = null;
      desktop = null;
      publicShare = null;
      createDirectories = true;
    };
    configFile."wired/wired.ron".text = lib.optionalString
      (pkgs.stdenv.buildPlatform.isLinux && gui.enable && !sosdEnabled)
      (import ../desktop/wired.nix { colors = gui.theme.colors; });

    configFile."dorion/config.json" = lib.mkIf (gui.enable) {
      source = ../desktop/dorion.json;
    };
  };

  security.rtkit.enable = pkgs.stdenv.buildPlatform.isLinux && gui.enable;
  xdg = lib.mkIf (pkgs.stdenv.buildPlatform.isLinux && gui.enable) {
    mime.enable = true;
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      wlr = {
        enable = builtins.elem "sway" wm.actives;
        settings.screencast = {
          chooser_type = "simple";
          chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -ro";
        };
      };
      config.common = {
        "default" = [ "gnome" "gtk" ];
        "org.freedesktop.impl.portal.Access"=[ "gtk" ];
        "org.freedesktop.impl.portal.Notification"=[ "gtk" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      };

      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];
    };
  };
}
