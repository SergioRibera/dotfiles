{ pkgs, inputs, config, lib, ... }: let
  inherit (config) gui user terminal shell wm services;

  enableJay = gui.enable && (builtins.elem "jay" wm.actives);
  tomlFormat = pkgs.formats.toml {};

  sosdEnabled = config.home-manager.users.${user.username}.programs.sosd.enable;

  mkRotation = r: if r == "left" then "rotate-270" else if r == "right" then "rotate-90" else if r == "inverted" then "flip" else "none";

  mkCmd = cmd: { type = "exec"; exec = cmd; };
in {
  home-manager.users.${user.username} = lib.mkIf (user.enableHM) ({ ... }: {
    home.packages = lib.optionals enableJay [ pkgs.jay ];
    xdg.configFile."jay/config.toml" = lib.mkIf enableJay ({
      source = tomlFormat.generate "config.toml" {
      on-graphics-initialized = [
        (mkCmd "swww-daemon")
        (mkCmd "sosd daemon")
        (mkCmd [ "dbus-update-activation-environment" "--all" "--systemd" ])
        (mkCmd ["${user.homepath}/.local/bin/wallpaper" "-t" "8h" "--no-allow-video" "-d" "-b" "-i" "${inputs.wallpapers}"])
      ];

      outputs = builtins.listToAttrs (builtins.map (o: {
        name = o.name;
        value = {
          name = o.name;
          match.name = o.name;
          x = o.position.x;
          y = o.position.y;
          scale = o.scale;
          vrr.mode = "variant3";
          tearing.mode = "always";
          transform = mkRotation o.rotation;
          mode = {
            width = o.resolution.x;
            height = o.resolution.y;
            refresh-rate = o.frequency;
          };
        };
      }) wm.screens);

      theme = {
        bg-color = "#000000";
        border-width = 0;
      };

      shortcuts = {
        "Super_L-h" = "focus-left";
        "Super_L-j" = "focus-down";
        "Super_L-k" = "focus-up";
        "Super_L-l" = "focus-right";

        "Super_L-shift-h" = "move-left";
        "Super_L-shift-j" = "move-down";
        "Super_L-shift-k" = "move-up";
        "Super_L-shift-l" = "move-right";

        "Super_L-tab" = mkCmd "sherlock";
        "Super_L-e" = mkCmd "cosmic-files";
        "Super_L-return" = mkCmd (terminal.command ++ shell.command);
        "Super_L-shift-return" = mkCmd (terminal.command ++ shell.privSession);
        "Super_L-b" = mkCmd ["nu" "${user.homepath}/.config/eww/scripts/extras.nu" "toggle" "sidebar"];
        "Super_L-p" = mkCmd ["nu" "${user.homepath}/.config/eww/scripts/extras.nu" "toggle" "power-screen"];
        "Super_L-m" = mkCmd ["nu" "${user.homepath}/.config/eww/scripts/extras.nu" "toggle" "screenkey"];
        "Super_L-y" = lib.mkIf sosdEnabled (mkCmd ["nu" "${user.homepath}/.local/bin/osd.nu" "show-time"]);
        "Super_L-c" = mkCmd ["hyprpicker" "-a" "-f" "hex"];
        "Super_L-period" = mkCmd ["simplemoji" "-t" "medium-light" "-soc" "wl-copy"];

        "Super_L-w" = mkCmd "close";
        "Super_L-semicolon" = mkCmd "toggle-split";
        "Super_L-f" = mkCmd "toggle-floating";
        "Super_L-shift-f" = mkCmd "toggle-fullscreen";
      } // (lib.attrsets.mergeAttrsList (
        map (x: let
          xStr = builtins.toString x;
        in {
          # generate move to tty
          "ctrl-alt-F${xStr}" = { type = "switch-to-vt"; num = x; };
          # generate to switch and move to workspaces
          "Super_L-${xStr}" = lib.optionalString (x <= 9) { type = "show-workspace"; name = xStr; };
          "Super_L-shift-${xStr}" = lib.optionalString (x <= 9) { type = "move-to-workspace"; name = xStr; };
        })
        (builtins.genList (x: x + 1) 12)
      ));

      # complex-shortcuts = let
      #   mkOsd = cmd: { latch = mkCmd ["nu" "${user.homepath}/.local/bin/osd.nu" cmd]; };
      #   mkPlayer = cmd: { action = mkCmd ["playerctl" cmd]; };
      # in {
      #   "XF86AudioPlay" = mkPlayer "play-pause";
      #   "XF86AudioStop" = mkPlayer "pause";
      #   "XF86AudioPrev" = mkPlayer "previous";
      #   "XF86AudioNext" = mkPlayer "next";
      # } ++ (lib.mkIf sosdEnabled {
      #   "XF86AudioMute" = mkOsd "audio-mute-toggle";
      #   "XF86AudioMicMute" = mkOsd "mic-mute-toggle";
      #
      #   "XF86AudioRaiseVolume" = mkOsd "volume-up";
      #   "XF86AudioLowerVolume" = mkOsd "volume-down";
      #
      #   "XF86MonBrightnessUp" = mkOsd "brightness-up";
      #   "XF86MonBrightnessDown" = mkOsd "brightness-down";
      #
      #   "Caps_Lock" = mkOsd "caps-lock";
      #   "Num_Lock" = mkOsd "num-lock";
      # });
    };});
  });
}
