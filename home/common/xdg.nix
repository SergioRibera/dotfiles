{ pkgs, config, lib, inputs, ... }:
let
  inherit (config) user gui;
in
with inputs.self.packages.${pkgs.system};
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

    configFile."vesktop/settings/settings.json" = lib.mkIf (gui.enable) {
      source = ../desktop/vesktop.json;
    };

    configFile."nushell/prompt.nu" = lib.mkIf (config.shell.name == "nushell") {
      source = ../shells/nushell/prompt.nu;
    };
    configFile."nushell/carapace.nu" = lib.mkIf (config.shell.name == "nushell") {
      source = ../shells/nushell/carapace.nu;
    };
  };

  xdg = lib.mkIf (pkgs.stdenv.buildPlatform.isLinux && gui.enable) {
    mime.enable = true;
    portal = {
      enable = true;
      gtkUsePortal = true;
      xdgOpenUsePortal = true;
      config.common.default = ["*"];
      extraPortals = [
        xdg-desktop-portal-cosmic
      ];
      configPackages = [
        xdg-desktop-portal-cosmic
      ];
    };
  };
}
