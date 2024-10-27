{ lib, config, pkgs, mkTheme, ... }:
let
  inherit (config) user gui;
  inherit (user) username;
  inherit (pkgs.stdenv.buildPlatform) isLinux;

  theme = mkTheme gui.theme.colors;

  darkTheme = {
    gtk-application-prefer-dark-theme = 1;
  };
in {
  home-manager.users = lib.mkIf user.enableHM {
    "${username}" = { lib, pkgs, ... }: {

      gtk = lib.mkIf (isLinux && gui.enable) {
        enable = true;
        gtk3.extraConfig = lib.mkIf (gui.theme.dark) darkTheme;
        gtk4.extraConfig = lib.mkIf (gui.theme.dark) darkTheme;
        gtk3.extraCss = theme.adwaitaGtk;
        gtk4.extraCss = theme.adwaitaGtk;
        theme = {
          name = "Orchis";
          package = pkgs.orchis-theme.overrideAttrs (oldAttrs: {
            border-radius = gui.theme.round;
            tweaks = [ "solid" "compact" ];
          });
        };
        iconTheme = {
          name = "Tela";
          package = pkgs.tela-icon-theme;
        };
      };

      dconf.settings."org/gnome/desktop/interface".color-scheme = lib.optionalString (isLinux && gui.enable) "prefer-dark";

      xdg.configFile."dorion/themes/default.css".text = theme.discord;

      home = {
        sessionVariables.GTK_THEME = lib.optionalString (isLinux && gui.enable) "Orchis";
        pointerCursor = lib.mkIf (isLinux && gui.enable) {
          gtk.enable = true;
          name = gui.cursor.name;
          package = gui.cursor.package;
          size = gui.cursor.size;
        };
      };
    };
  };
}
