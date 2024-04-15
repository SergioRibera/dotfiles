{ config, ... }:
let
  inherit (config) user;
  shell = user.shell.pname;
in
{
  programs = {
    "${shell}".enable = true;

    adb.enable = true;
    thunar = {
      enable = user.enableGUI;
      plugins = [ ];
    };

    hyprland.enable = user.enableGUI;
    firefox = {
      enable = user.enableGUI;
      preferencesStatus = "user";
    };
  };
}
