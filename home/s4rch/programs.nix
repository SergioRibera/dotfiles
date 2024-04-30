{ config, lib, ... }:
let
  inherit (config) gui;
in
{
  programs = {
    adb.enable = true;
    thunar = {
      enable = gui.enable;
      plugins = [ ];
    };

    firefox = lib.mkIf (gui.enable && config.user.browser == "firefox") (import ../../modules/browser/firefox.nix { inherit config; });
    chromium = lib.mkIf (gui.enable && config.user.browser == "chromium") (import ../../modules/browser/chromium.nix { inherit config; });
  };
}
