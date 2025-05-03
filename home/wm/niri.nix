{ inputs, config, lib, pkgs, ... }: let
  inherit (config) gui user terminal shell;
  command = terminal.command;
  sosdEnabled = config.home-manager.users.${user.username}.programs.sosd.enable;
  makeCommand = command: {
    command = [command];
  };
  makeCommandArgs = command: {
    command = command;
  };
in {
  home-manager.users.${user.username} = lib.mkIf (user.enableHM) ({config, ...}: {
    imports = [
      inputs.niri.homeModules.niri
    ];

    home.file.".local/bin/osd.nu" = lib.mkIf (gui.enable && sosdEnabled) {
      executable = true;
      source = ../../scripts/osd.nu;
    };

    programs.niri = {
      enable = true;
      settings = {
        prefer-no-csd = true;
        hotkey-overlay.skip-at-startup = true;
        screenshot-path = "~/Pictures/Screenshot/%Y-%m-%d_%H%M%S.png";
        environment = {
          DISPLAY = ":0";
          QT_QPA_PLATFORM = "wayland";
          QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        };
        spawn-at-startup = [
          (makeCommand "swww-daemon")
          (makeCommand "${pkgs.xwayland-satellite}/bin/xwayland-satellite")
          (makeCommandArgs ["sosd" "daemon"])
          (makeCommandArgs ["${user.homepath}/.local/bin/wallpaper" "-t" "8h" "--no-allow-video" "-d" "-b" "-i" "${inputs.wallpapers}"])
          (
            makeCommandArgs [
              "dbus-update-activation-environment"
              "--systemd"
              "DISPLAY"
              "WAYLAND_DISPLAY"
              "SWAYSOCK"
              "XDG_CURRENT_DESKTOP"
              "XDG_SESSION_TYPE"
              "NIXOS_OZONE_WL"
              "XCURSOR_THEME"
              "XCURSOR_SIZE"
              "XDG_DATA_DIRS"
              "FLAKE"
              "PATH"
              "WLR_DRM_DEVICES"
            ]
          )
        ];
        input = {
          keyboard.xkb = {
            layout = "us";
            variant = "altgr-intl";
          };
          touchpad = {
            dwt = true;
            dwtp = true;
            natural-scroll = true;
            scroll-method = "two-finger";
            tap = true;
            tap-button-map = "left-right-middle";
          };
          focus-follows-mouse.enable = true;
          warp-mouse-to-focus = true;
        };
        outputs = {
          "eDP-1" = {
            scale = 1.0;
            position = {
              x = 1080;
              y = 1202;
            };
          };
          "HDMI-A-1" = {
            scale = 0.9;
            mode = {
              width = 1920;
              height = 1080;
              refresh = 60.0;
            };
            position = {
              x = 1080;
              y = 0;
            };
          };
          "DVI-I-2" = {
            scale = 1.0;
            mode = {
              width = 1920;
              height = 1080;
              refresh = 60.0;
            };
            position = {
              x = 0;
              y = 0;
            };
            transform.rotation = 90;
          };
        };
        layout =  let
          dist_in = 7;
          dist_out = 5;
        in {
          focus-ring.enable = false;
          preset-column-widths = [
            {proportion = 1.0 / 3.0;}
            {proportion = 1.0 / 2.0;}
            {proportion = 2.0 / 3.0;}
          ];
          default-column-width = { proportion = 1.0; };

          gaps = dist_in;
          struts = {
            left = dist_out;
            right = dist_out;
            top = dist_out;
            bottom = dist_out;
          };
        };
        binds = with config.lib.niri.actions; let
          terminal = spawn command;
          playerctl = cmd: {
            allow-when-locked = true;
            action.spawn = ["playerctl"] ++ cmd;
          };

          osd = ms: cmd: {
            allow-when-locked = true;
            cooldown-ms = ms;
            action.spawn = ["nu" "${user.homepath}/.local/bin/osd.nu"] ++ cmd;
          };
        in
          {
            "XF86AudioMute" = lib.mkIf sosdEnabled (osd 500 ["audio-mute-toggle"]);
            "XF86AudioMicMute" = lib.mkIf sosdEnabled (osd 500 ["mic-mute-toggle"]);

            "XF86AudioPlay" = playerctl ["play-pause"];
            "XF86AudioStop" = playerctl ["pause"];
            "XF86AudioPrev" = playerctl ["previous"];
            "XF86AudioNext" = playerctl ["next"];

            "XF86AudioRaiseVolume" = lib.mkIf sosdEnabled (osd 0 ["volume-up"]);
            "XF86AudioLowerVolume" = lib.mkIf sosdEnabled (osd 0 ["volume-down"]);

            "XF86MonBrightnessUp" = lib.mkIf sosdEnabled (osd 0 ["brightness-up"]);
            "XF86MonBrightnessDown" = lib.mkIf sosdEnabled (osd 0 ["brightness-down"]);

            "Caps_Lock" = lib.mkIf sosdEnabled (osd 500 ["caps-lock"]);
            "Num_Lock" = lib.mkIf sosdEnabled (osd 500 ["num-lock"]);

            "Mod+S".action = screenshot-window { write-to-disk = false; };
            "Mod+Print".action = screenshot-window;
            "Mod+Shift+S".action = screenshot;

            "Mod+Tab".action = spawn "anyrun";
            "Mod+E".action = spawn "cosmic-files";
            "Mod+Return".action = terminal shell.command;
            # TODO: replace harcoded path by dynamic path from config
            "Mod+B".action = spawn "nu" "${user.homepath}/.config/eww/scripts/extras.nu" "toggle" "sidebar";
            "Mod+P".action = spawn "nu" "${user.homepath}/.config/eww/scripts/extras.nu" "toggle" "power-screen";
            "Mod+M".action = spawn "nu" "${user.homepath}/.config/eww/scripts/extras.nu" "toggle" "screenkey";
            "Mod+Shift+Return".action = terminal shell.privSession;
            "Mod+C".action = spawn "hyprpicker" "-a" "-f" "hex";
            "Mod+Period".action = spawn "simplemoji" "-t" "medium-light" "-soc" "wl-copy";

            "Mod+Shift+T".action = toggle-debug-tint;

            "Mod+W".action = close-window;
            "Mod+D".action = maximize-column;
            "Mod+F".action = toggle-window-floating;
            "Mod+Shift+F".action = fullscreen-window;

            "Mod+Comma".action = consume-window-into-column;
            "Mod+Semicolon".action = expel-window-from-column;

            "Mod+H".action = focus-column-or-monitor-left;
            "Mod+L".action = focus-column-or-monitor-right;
            "Mod+J".action = focus-window-or-workspace-down;
            "Mod+K".action = focus-window-or-workspace-up;

            "Mod+Shift+H".action = move-column-left-or-to-monitor-left;
            "Mod+Shift+L".action = move-column-right-or-to-monitor-right;
            "Mod+Shift+J".action = move-window-down-or-to-workspace-down;
            "Mod+Shift+K".action = move-window-up-or-to-workspace-up;

            "Mod+WheelScrollDown" = {
              action = focus-workspace-down;
              cooldown-ms = 150;
            };
            "Mod+WheelScrollUp" = {
              action = focus-workspace-up;
              cooldown-ms = 150;
            };
          }
          // (lib.attrsets.mergeAttrsList (
            map (x: let
              xStr = builtins.toString x;
            in {
              "Mod+${xStr}".action = focus-workspace x;
              "Mod+Shift+${xStr}".action = move-column-to-workspace x;
            })
            (builtins.genList (x: x + 1) 9)
          ));
        window-rules = [
          {
            geometry-corner-radius = let
              radius = 5.0;
            in {
              bottom-left = radius;
              bottom-right = radius;
              top-left = radius;
              top-right = radius;
            };
            clip-to-geometry = true;
            open-maximized = true;
          }
          {
            matches = [
              { app-id = "^org\.keepassxc\.KeePassXC$"; }
              { app-id = "^org\.gnome\.World\.Secrets$"; }
            ];
            block-out-from = "screen-capture";
          }
        ];
      };
    };
  });
}
