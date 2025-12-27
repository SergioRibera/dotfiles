{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (config) user gui;
  inherit (user) username;
  inherit (pkgs.stdenv.buildPlatform) isLinux;

  darkTheme = {
    gtk-application-prefer-dark-theme = 1;
  };
in
{
  home-manager.users = lib.mkIf user.enableHM {
    "${username}" =
      { lib, pkgs, ... }:
      {

        gtk = lib.mkIf (isLinux && gui.enable) {
          enable = true;
          gtk3.extraConfig = lib.mkIf (gui.theme.dark) darkTheme;
          gtk4.extraConfig = lib.mkIf (gui.theme.dark) darkTheme;
          iconTheme = {
            name = "Tela";
            package = pkgs.tela-icon-theme;
          };
        };

        dconf.settings."org/gnome/desktop/interface" = lib.mkIf (isLinux && gui.enable) {
          gtk-theme = gui.theme.gtk;
          color-scheme = "prefer-dark";
        };

        home = {
          pointerCursor = lib.mkIf (isLinux && gui.enable) {
            gtk.enable = true;
            name = gui.cursor.name;
            package = gui.cursor.package;
            size = gui.cursor.size;
          };
        };
      };
  };
  environment.sessionVariables.GTK_THEME = lib.optionalString (isLinux && gui.enable) "Adwaita:dark";
}
