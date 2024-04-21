{ config, ... }:
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

    firefox = {
      enable = gui.enable;
      preferencesStatus = "user";
    };
  };
}
