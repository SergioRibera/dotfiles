{ config, ... }:
let
  inherit (config) user gui;
  shell = user.shell;
in
{
  programs = {
    # "${shell}".enable = true;

    adb.enable = true;
    thunar = {
      enable = gui.enable;
      plugins = [ ];
    };

    hyprland.enable = gui.enable;
    firefox = {
      enable = gui.enable;
      preferencesStatus = "user";
    };
  };
}
