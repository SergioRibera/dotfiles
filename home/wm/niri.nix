{ inputs, config, lib, pkgs, ... }: let
  inherit (config) gui user terminal shell wm;
  command = terminal.command;
  sosdEnabled = config.home-manager.users.${user.username}.programs.sosd.enable;
  makeCommand = command: {
    command = [command];
  };
  makeCommandArgs = command: {
    command = command;
  };
  mkRotation = rot: if rot == "left" then 270 else if rot == "right" then 90 else if rot == "inverted" then 180 else 0;
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
      enable = gui.enable && (builtins.elem "niri" wm.actives);
      # package = inputs.niri-pkg.packages.${pkgs.system}.default;
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
          (makeCommandArgs [ "dbus-update-activation-environment" "--all" "--systemd" ])
        ];
        input = {
          keyboard.xkb = {
            layout = "us";
            variant = "altgr-intl";
          };
          touchpad = lib.mkIf gui.touchpad {
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
        outputs = builtins.listToAttrs (builtins.map (o: {
          name = o.name;
          value = {
            scale = o.scale;
            position = {
              x = o.position.x;
              y = o.position.y;
            };
            mode = {
              width = o.resolution.x;
              height = o.resolution.y;
              refresh = o.frequency;
            };
            transform.rotation = mkRotation o.rotation;
          };
        }) wm.screens);
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
        binds = with config.lib.niri.actions; with inputs.niri.lib.kdl; let
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
            # "Mod+J".action = magic-leaf "focus-window-or-workspace-or-monitor-down";
            # "Mod+K".action = magic-leaf "focus-window-or-workspace-or-monitor-up";

            "Mod+Shift+H".action = move-column-left-or-to-monitor-left;
            "Mod+Shift+L".action = move-column-right-or-to-monitor-right;
            "Mod+Shift+J".action = move-window-down-or-to-workspace-down;
            "Mod+Shift+K".action = move-window-up-or-to-workspace-up;
            # "Mod+Shift+J".action = magic-leaf "move-window-down-or-to-workspace-down-or-to-monitor-down";
            # "Mod+Shift+K".action = magic-leaf "move-window-up-or-to-workspace-up-or-to-monitor-up";

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
