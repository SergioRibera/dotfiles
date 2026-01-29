{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (config) user gui wm;
  isWmEnable = name: builtins.elem name wm.actives;
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
    configFile."dorion/config.json" = lib.mkIf (gui.enable) {
      source = ../desktop/dorion.json;
    };
  };

  xdg = lib.mkIf (pkgs.stdenv.buildPlatform.isLinux && gui.enable) {
    mime.enable = true;
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      wlr = {
        enable = isWmEnable "sway" || isWmEnable "mango";
        settings.screencast = {
          chooser_type = "simple";
          chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -ro";
        };
      };
      config.common = {
        "default" = lib.optionals (isWmEnable "jay") [ "jay" ] ++ [
          "gnome"
          "gtk"
        ];
        "org.freedesktop.impl.portal.Access" = [ "gtk" ];
        "org.freedesktop.impl.portal.Notification" = [ "gtk" ];
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
