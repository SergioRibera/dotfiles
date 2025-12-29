{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config)
    gui
    user
    terminal
    shell
    wm
    services
    ;
  makeCommand = command: {
    command = [ command ];
  };
  makeCommandArgs = command: {
    command = command;
  };
  mkRotation =
    rot:
    if rot == "left" then
      270
    else if rot == "right" then
      90
    else if rot == "inverted" then
      180
    else
      0;
in
{
  home-manager.users.${user.username} = lib.mkIf (user.enableHM) (
    { config, ... }:
    {
      imports = [
        inputs.niri.homeModules.niri
      ];

      programs.niri = {
        enable = gui.enable && (builtins.elem "niri" wm.actives);
        # package = inputs.niri.packages.${pkgs.system}.niri-stable;
        package = inputs.niri-pkg.packages.${pkgs.system}.default;
        settings =
          with config.lib.niri.actions;
          with inputs.niri.lib.kdl;
          {
            prefer-no-csd = true;
            hotkey-overlay.skip-at-startup = true;
            screenshot-path = "~/Pictures/Screenshot/%Y-%m-%d_%H%M%S.png";
            environment = {
              DISPLAY = ":0";
            };
            spawn-at-startup = [
              (makeCommandArgs [
                "dms"
                "run"
              ])
              (makeCommandArgs [
                "${pkgs.wl-clipboard-rs}/bin/wl-paste"
                "--watch"
                "${pkgs.cliphist}/bin/cliphist"
                "store"
              ])
              (makeCommand "${pkgs.xwayland-satellite}/bin/xwayland-satellite")
              (makeCommandArgs [
                "dbus-update-activation-environment"
                "--all"
                "--systemd"
              ])
            ];
            # cursor = (plain "cursor" [ (leaf "shake" (flag "on")) ]);
            input = {
              keyboard = {
                numlock = true;
                xkb = with services.xserver; {
                  layout = xkb.layout;
                  variant = xkb.variant;
                };
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
              warp-mouse-to-focus = {
                enable = true;
                mode = "center-xy";
              };
            };
            outputs = builtins.listToAttrs (
              builtins.map (o: {
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
                  backdrop-color = "#000";
                  transform.rotation = mkRotation o.rotation;
                };
              }) wm.screens
            );
            layout =
              let
                dist_in = 7;
                dist_out = 5;
              in
              {
                background-color = "transparent";
                focus-ring.enable = false;
                preset-column-widths = [
                  { proportion = 1.0 / 3.0; }
                  { proportion = 1.0 / 2.0; }
                  { proportion = 2.0 / 3.0; }
                ];
                default-column-width = {
                  proportion = 1.0;
                };

                gaps = dist_in;
                struts = {
                  left = dist_out;
                  right = dist_out;
                  top = dist_out;
                  bottom = dist_out;
                };
              };
            binds =
              let
                playerctl = cmd: {
                  allow-when-locked = true;
                  action.spawn = [
                    "dms"
                    "ipc"
                    "call"
                    "mpris"
                    cmd
                  ];
                };

                osd = ms: cmd: plus: value: {
                  allow-when-locked = true;
                  cooldown-ms = ms;
                  action.spawn = [
                    "dms"
                    "ipc"
                    "call"
                    cmd
                    (if plus then "increment" else "decrement")
                    value
                  ];
                };

                dms-ipc = cmd: value: {
                  action.spawn = [
                    "dms"
                    "ipc"
                    "call"
                    cmd
                    (if value == null then "toggle" else value)
                  ];
                };

                dms-niri = cmd: {
                  action.spawn = [
                    "dms"
                    "ipc"
                    "call"
                    "niri"
                    cmd
                  ];
                };
              in
              {
                "XF86AudioMute" = dms-ipc "audio" "mute";
                "XF86AudioMicMute" = dms-ipc "audio" "micmute";

                "XF86AudioPlay" = playerctl "playPause";
                "XF86AudioStop" = playerctl "pause";
                "XF86AudioPrev" = playerctl "previous";
                "XF86AudioNext" = playerctl "next";

                "XF86AudioRaiseVolume" = osd 0 "audio" true "5";
                "XF86AudioLowerVolume" = osd 0 "audio" false "5";

                "XF86MonBrightnessUp" = osd 0 "brightness" true "5";
                "XF86MonBrightnessDown" = osd 0 "brightness" false "5";

                "Mod+S" = dms-niri "screenshotWindow";
                "Mod+Print" = dms-niri "screenshotWindow";
                "Mod+Shift+S" = dms-niri "screenshot";

                "Mod+Escape".action = toggle-overview;
                "Mod+E".action.spawn = "nautilus";
                "Mod+Return".action.spawn = terminal.command ++ shell.command;
                "Mod+Shift+Return".action.spawn = terminal.command ++ shell.privSession;

                "Mod+Tab" = dms-ipc "spotlight" null;
                "Mod+P" = dms-ipc "powermenu" null;
                "Mod+V" = dms-ipc "clipboard" null;
                "Mod+N" = dms-ipc "notepad" null;
                "Mod+C".action.spawn = [
                  "dms"
                  "color"
                  "pick"
                  "-a"
                ];
                "Mod+I" = dms-ipc "settings" "focusOrToggle";
                "Mod+Alt+L" = dms-ipc "lock" "lock";

                # "Mod+M".action = ["dms" "ipc" "call" "screenkey" "toggle"];
                "Mod+Period".action.spawn = [
                  "simplemoji"
                  "--show-recent"
                  "--recent-type"
                  "mixed"
                  "-t"
                  "medium-light"
                  "-soc"
                  "wl-copy"
                ];

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
                map (
                  x:
                  let
                    xStr = builtins.toString x;
                  in
                  {
                    "Mod+${xStr}".action.focus-workspace = x;
                    "Mod+Shift+${xStr}".action.move-column-to-index = x;
                  }
                ) (builtins.genList (x: x + 1) 9)
              ));
            layer-rules = [
              {
                matches = [ { namespace = "^quickshell$"; } ];
                place-within-backdrop = true;
              }
              {
                matches = [ { namespace = "dms:blurwallpaper"; } ];
                place-within-backdrop = true;
              }
            ];
            window-rules = [
              {
                geometry-corner-radius =
                  let
                    radius = 5.0;
                  in
                  {
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
              {
                matches = [ { app-id = "org.quickshell$"; } ];
                open-floating = true;
              }

              {
                matches = [
                  { app-id = "^org.gnome."; }
                  { app-id = "Alacritty"; }
                ];
                draw-border-with-background = false;
              }
            ];
          };
      };
    }
  );
}
