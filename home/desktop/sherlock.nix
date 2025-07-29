{ config, inputs, lib, pkgs, ... }:
let
  inherit (config) terminal user gui;
in {
  home-manager.users.${user.username} = lib.mkIf user.enableHM ({ ... }: {
    imports = [
      inputs.sherlock.homeModules.default
    ];

    programs.sherlock = {
      enable = pkgs.stdenv.buildPlatform.isLinux && gui.enable && user.enableHM;
      settins = {
        config = {
          debug.try_suppress_warnings = true;
          default_apps.terminal = lib.strings.concatStringsSep " " terminal.command;
          binds = {
            prev = "shift+tab";
            next = "tab";
          };
        };
        style = null;
        ignore = ''
          Avahi*
        '';
        launchers = [];
      };
    };
  });
}
