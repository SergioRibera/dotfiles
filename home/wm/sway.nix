{ inputs, config, lib, pkgs, ... }: let
  inherit (config) user terminal shell gui;
  mod = "Mod4";
in {
  programs.sway = {
    wrapperFeatures.gtk = true;
    extraOptions = [ "--unsupported-gpu" ];
  };
  home-manager.users.${user.username} = lib.mkIf user.enableHM {
    wayland.windowManager.sway = lib.mkIf (pkgs.stdenv.buildPlatform.isLinux && gui.enable) {
      enable = true;
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
        # bars = [];
        menu = "anyrun";
        terminal = terminal.name;
        gaps.inner = 7;
        floating.border = 1;
        focus.followMouse = true;
        startup = [
          { always = true; command = "swww-daemon"; }
          {
            always = true;
            command = "${user.homepath}/.local/bin/wallpaper -t 8h --no-allow-video -d -b -i ${inputs.wallpapers}";
          }
        ];
        window = {
          border = 0;
          titlebar = false;
        };
        modifier = mod;
        input = {
          keyboard = {
            xkb_layout = "us";
            xkb_variant = "altgr-intl";
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
        output = {
          "eDP-1" = {
            pos = "1080 0";
          };
          "DVI-I-1" = {
            mode = "1920x1080";
            pos = "0 1600";
          };
          "DVI-I-2" = {
            mode = "1920x1080";
            pos = "0 -1080";
            transform = "270";
          };
        };
        keybindings = {
          "${mod}+Tab" = "exec anyrun";
          "${mod}+e" = "exec cosmic-files";
          "${mod}+Return" = "exec " + (lib.strings.concatStringsSep " " (terminal.command ++ shell.command));
          "${mod}+Shift+Return" = "exec " + (lib.strings.concatStringsSep " " (terminal.command ++ shell.privSession));
          "${mod}+n" = "exec firefox-developer-edition";

          "${mod}+w" = "kill";
          "${mod}+f" = "floating toggle";

          "${mod}+h" = "focus left";
          "${mod}+j" = "focus down";
          "${mod}+k" = "focus up";
          "${mod}+l" = "focus right";

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
      };
    };
  };
}
