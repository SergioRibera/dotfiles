{ config, lib, pkgs, ... }:
let
  inherit (config) nvim gui;
in
{
  programs = {
    adb.enable = nvim.complete;
    thunar = {
      enable = gui.enable;
      plugins = [ ];
    };

    # firefox = lib.mkIf (gui.enable && config.user.browser == "firefox") (import ../modules/browser/firefox.nix { inherit lib pkgs config; });
    chromium = lib.mkIf (gui.enable && config.user.browser == "chromium") (import ../modules/browser/chromium.nix { inherit config; });
  };
}
