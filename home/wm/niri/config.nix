{ config, lib, pkgs, inputs, ... }: let
  makeCommand = command: {
    command = [command];
  };
in {
  programs.niri = {
    enable = true;
    settings = {
      prefer-no-csd = true;
      hotkey-overlay.skip-at-startup = true;
      screenshot-path = "~/Pictures/Screenshot/%Y-%m-%d %H-%M-%S.png";
      environment = {
        QT_QPA_PLATFORM = "wayland";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      };
      spawn-at-startup = [
        (makeCommand "udiskie")
        (makeCommand "thunar --daemon")
        (makeCommand "swww-daemon")
        (makeCommand "wallpaper -t 8h --no-allow-video -d -b -i \"${inputs.wallpapers}\"")
        {
          command = [
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
          ];
        }
      ];
      input = {
        keyboard.xkb.layout = "us";
        touchpad = {
          dwt = true;
          dwtp = true;
          natural-scroll = true;
          scroll-method = "two-finger";
          tap = true;
          tap-button-map = "left-right-middle";
        };
        focus-follows-mouse = true;
        warp-mouse-to-focus = true;
        workspace-auto-back-and-forth = true;
      };
      outputs = {
        "eDP-1" = {
          scale = 1.0;
          position = {
            x = 0;
            y = 0;
          };
        };
        "HDMI-A-1" = {
          scale = 1.0;
          mode = {
            width = 1920;
            height = 1080;
            refresh = 60.0;
          };
          position = {
            x = 0;
            y = -1080;
          };
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
        # terminal = spawn "wezterm" "start";
        terminal = spawn "foot";
        set-volume = spawn "swayosd-client" "--output-volume";
        brightness = spawn "swayosd-client" "--brightness";
        playerctl = spawn "${pkgs.playerctl}/bin/playerctl";
      in
        {
          "XF86AudioMute".action = spawn "swayosd-client" "--output-volume" "mute-toggle";
          "XF86AudioMicMute".action = spawn "swayosd-client" "--input-volume" "mute-toggle";

          "XF86AudioPlay".action = playerctl "play-pause";
          "XF86AudioStop".action = playerctl "pause";
          "XF86AudioPrev".action = playerctl "previous";
          "XF86AudioNext".action = playerctl "next";

          "XF86AudioRaiseVolume".action = set-volume "raise";
          "XF86AudioLowerVolume".action = set-volume "lower";

          "XF86MonBrightnessUp".action = brightness "raise";
          "XF86MonBrightnessDown".action = brightness "lower";

          "Caps_Lock".action = spawn "swayosd-client" "--caps-lock";
          "Num_Lock".action = spawn "swayosd-client" "--num-lock";

          "Print".action = screenshot-screen;
          "Mod+Shift+Alt+S".action = screenshot-window;
          "Mod+Shift+S".action = screenshot;

          "Mod+Tab".action = spawn "anyrun";
          "Mod+E".action = spawn "thunar";
          "Mod+Return".action = terminal;
          "Mod+Shift+Return".action = terminal config.shell.privSession;
          "Mod+C".action = spawn "hyprpicker" "-a" "-f" "hex";

          "Mod+W".action = close-window;
          "Mod+F".action = maximize-column;
          "Mod+Shift+F".action = fullscreen-window;

          "Mod+Comma".action = consume-window-into-column;
          "Mod+Period".action = expel-window-from-column;

          "Mod+Minus".action = set-column-width "-10%";
          "Mod+Plus".action = set-column-width "+10%";
          "Mod+Shift+Minus".action = set-window-height "-10%";
          "Mod+Shift+Plus".action = set-window-height "+10%";

          "Mod+H".action = focus-column-left;
          "Mod+L".action = focus-column-right;
          "Mod+J".action = focus-workspace-down;
          "Mod+K".action = focus-workspace-up;

          "Mod+Shift+H".action = move-column-left;
          "Mod+Shift+L".action = move-column-right;
          "Mod+Shift+J".action = move-window-down;
          "Mod+Shift+K".action = move-window-up;

          "Mod+Shift+Ctrl+H".action = move-column-to-workspace-up;
          "Mod+Shift+Ctrl+J".action = move-column-to-monitor-down;
          "Mod+Shift+Ctrl+K".action = move-column-to-monitor-up;
          "Mod+Shift+Ctrl+L".action = move-column-to-workspace-down;
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
          default-column-width = {};
        }
        {
          matches = [{ app-id = "org.telegram.desktop"; }];
          block-out-from = "screen-capture";
        }
      ];
    };
  };
}
