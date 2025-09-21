{ config, lib, pkgs, ... }:
let
  inherit (config) terminal user gui;
in {
  home-manager.users.${user.username} = lib.mkIf user.enableHM ({ ... }: {
    programs.sherlock = {
      enable = pkgs.stdenv.buildPlatform.isLinux && gui.enable && user.enableHM;
      settings = {
        debug.try_suppress_warnings = true;
        default_apps.terminal = lib.strings.concatStringsSep " " terminal.command;
        binds = {
          prev = "shift+tab";
          next = "tab";
        };
      };
      ignore = ''
        Avahi*
      '';
      aliases = {
        nvim = {
           name = "Neovide";
           icon = "Neovide";
           keywords = "neovide neovim nvim vim";
        };
      };
      launchers = [
        {
          name = "Calculator";
          type = "calculation";
          args.capabilities = [
            "calc.math"
            "calc.units"
          ];
          priority = 1;
        }
        {
          name = "Media";
          type = "audio_sink";
          args = {};
          async = true;
          priority = 1;
          home = true;
          only_home = true;
          spawn_focus = false;
        }
        {
          name = "Clipboard";
          type = "clipboard-execution";
          args.capabilities = [
            "url"
            "colors.hex"
            "colors.rgb"
            "colors.hsl"
            "calc.math"
            "calc.lengths"
            "calc.weights"
            "calc.temperatures"
          ];
          priority = 1;
          home = true;
        }
        {
          name = "App Launcher";
          alias = "app";
          type = "app_launcher";
          args = {};
          priority = 2;
          home = true;
        }
        {
          name = "Categories";
          alias = "cat";
          type = "categories";
          args = {
            "Kill Processes" = {
              icon = "sherlock-process";
              icon_class = "reactive";
              exec = "kill";
              search_string = "terminate;kill;process";
            };
            "Power Menu" = {
              icon = "battery-full-symbolic";
              icon_class = "reactive";
              exec = "pm";
              search_string = "powermenu;";
            };
          };
          priority = 3;
          home = true;
        }
        {
          name = "Kill Process";
          alias = "kill";
          type = "process";
          args = {};
          priority = 0;
        }
        {
          name = "Power Management";
          alias = "pm";
          type = "command";
          args = {
            commands = {
              "Shutdown" = {
                icon = "system-shutdown";
                icon_class = "reactive";
                exec = "poweroff";
                search_string = "Poweroff;Shutdown";
              };
              "Sleep" = {
                icon = "system-suspend";
                icon_class = "reactive";
                exec = "suspend";
                search_string = "Sleep;";
              };
              # "Lock = {
              #     "icon = "system-lock-screen";
              #     "icon_class = "reactive";
              #     "exec = "systemctl suspend & swaylock";
              #     "search_string = "Lock Screen;"
              # };
              "Reboot" = {
                icon = "system-reboot";
                icon_class = "reactive";
                exec = "reboot";
                search_string = "reboot;restart";
              };
            };
          };
          priority = 5;
        }
        {
          name = "Web Search";
          display_name = "Google Search";
          tag_start = "{keyword}";
          tag_end = "{keyword}";
          alias = "gg";
          type = "web_launcher";
          args = {
            search_engine = "google";
            icon = "google";
          };
          priority = 100;
        }
      ];
    };
  });
}
