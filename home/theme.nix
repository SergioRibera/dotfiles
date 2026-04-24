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
  extraCss = v: ''
@import url("file://${user.homepath}/.config/gtk-${v}.0/dank-colors.css");

window {
    background-color: alpha(@window_bg_color, 0.7);
}
window.nautilus-window .sidebar-pane {
    background-color: transparent;
}
window.nautilus-window .content-pane {
    background-color: @view_bg_color;
}
  '';
  gtkThemeConfig = v: {
    extraConfig = lib.mkIf (gui.theme.dark) darkTheme;
    extraCss = extraCss v;
  };
in
{
  home-manager.users = lib.mkIf user.enableHM {
    "${username}" =
      { lib, pkgs, ... }:
      {
        gtk = lib.mkIf (isLinux && gui.enable) {
          enable = true;
          theme = {
            name = gui.theme.gtk;
            package = gui.theme.gtk-pkg;
          };
          gtk3 = gtkThemeConfig "3";
          gtk4 = gtkThemeConfig "4";
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
  environment.sessionVariables.GTK_THEME = lib.optionalString (isLinux && gui.enable) gui.theme.gtk-theme-env;
}
