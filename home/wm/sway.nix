{ config, lib, pkgs, ... }: let
  inherit (config) user terminal shell gui wm;
  mod = "Mod4";
  # osd = cmd: plus: value: "dms ipc call ${cmd} ${if plus then "increment" else "decrement"} ${value}";
  dms-ipc = cmd: action: "dms ipc call ${cmd} ${if action == null then "toggle" else action}";
  mkRotation = rot: if rot == "left" then "90" else if rot == "right" then "270" else if rot == "inverted" then "180" else "normal";
in {
  home-manager.users.${user.username} = lib.mkIf user.enableHM {
    wayland.windowManager.sway = lib.mkIf (pkgs.stdenv.buildPlatform.isLinux && gui.enable) {
      enable = builtins.elem "sway" wm.actives;
      extraOptions = ["--unsupported-gpu"];
      wrapperFeatures.gtk = true;
      systemd = {
        enable = true;
        variables = ["--all"];
        xdgAutostart = true;
      };
      config = {
        colors = let
          c = gui.theme.colors;
        in {
          background = c.base00;
          focused = {
            background = c.base0D;
            border = c.base0D;
            childBorder = c.base0D;
            indicator = c.base0D;
            text = c.base0B;
          };
        };
        menu = dms-ipc "spotlight";
        terminal = terminal.name;
        gaps.inner = 7;
        floating.border = 1;
        focus.followMouse = true;
        startup = [ ];
        window = {
          border = 0;
          titlebar = false;
        };
        modifier = mod;
        input = {
          keyboard = with config.services.xserver; {
            xkb_layout = xkb.layout;
            xkb_variant = xkb.variant;
            xkb_options = xkb.options;
          };
          # touchpad = lib.optional (gui.touchpad) {
          #   dwt = true;
          #   dwtp = true;
          #   natural-scroll = true;
          #   scroll-method = "two-finger";
          #   tap = true;
          #   tap-button-map = "left-right-middle";
          # };
          # set pointer of sway wn
          # pointer = {
          #   cursor = "left_ptr";
          # };
        };
        output = builtins.listToAttrs (builtins.map (o: {
          name = o.name;
          value = {
            scale = builtins.toString o.scale;
            pos = "${builtins.toString o.position.x} ${builtins.toString o.position.y}";
            resolution = "${builtins.toString o.resolution.x}x${builtins.toString o.resolution.y}@${builtins.toString o.frequency}Hz";
            transform = mkRotation o.rotation;
          };
        }) wm.screens);
        keybindings = {
          # DMS
          "${mod}+Tab" = "exec ${dms-ipc "spotlight"}";
          "${mod}+P" = "exec ${dms-ipc "powermenu"}";
          "${mod}+V" = "exec ${dms-ipc "clipboard"}";
          "${mod}+N" = "exec ${dms-ipc "notepad"}";
          "${mod}+C" = "exec dms color pick -a";
          "${mod}+I" = "exec ${dms-ipc "settings" "focusOrToggle"}";
          "${mod}+L" = "exec ${dms-ipc "lock" "lock"}";

          "${mod}+e" = "exec nautilus";
          "${mod}+Return" = "exec " + (lib.strings.concatStringsSep " " (terminal.command ++ shell.command));
          "${mod}+Shift+Return" = "exec " + (lib.strings.concatStringsSep " " (terminal.command ++ shell.privSession));

          "${mod}+w" = "kill";
          "${mod}+f" = "floating toggle";

          "${mod}+h" = "focus left";
          "${mod}+j" = "focus down";
          "${mod}+k" = "focus up";
          "${mod}+l" = "focus right";

          "${mod}+period" = "exec simplemoji --show-recent --recent-type mixed -t medium-light -soc wl-copy";

          "${mod}+Shift+h" = "move left";
          "${mod}+Shift+j" = "move down";
          "${mod}+Shift+k" = "move up";
          "${mod}+Shift+l" = "move right";
        } // (lib.attrsets.mergeAttrsList (
          map (x: let
            xs = builtins.toString x;
          in {
            "${mod}+${xs}" = "workspace number ${xs}";
            "${mod}+Shift+${xs}" = "move container to workspace number ${xs}";
          })
          (builtins.genList (x: x + 1) 9)
        ));
        # bars = [];
      };
    };
  };
}
