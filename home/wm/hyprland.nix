{ inputs, config, lib, pkgs, ... }: let
  inherit (config) user gui;
  isLinux = pkgs.stdenv.buildPlatform.isLinux;
  sosdEnabled = config.home-manager.users.${user.username}.programs.sosd.enable;
  sosdCmd = "nu ${user.homepath}/.local/bin/osd.nu";
in {
  home-manager.users.${user.username} = lib.mkIf user.enableHM {

    home.file.".local/bin/osd.nu" = lib.mkIf (isLinux && gui.enable && sosdEnabled) {
      executable = true;
      source = ../../scripts/osd.nu;
    };

    wayland.windowManager.hyprland = lib.mkIf (isLinux && gui.enable) {
      enable = true;
      xwayland.enable = true;
      settings = {
        monitor = [ "eDP-1,1600x900@60,1080x1020,1" "HDMI-A-1,1920x1080@60,0x0,1,transform,3" ];
        workspace = [ "eDP-1,10" "HDMI-A-1,10" ];
        exec-once = [
          "dbus-update-activation-environment DISPLAY XAUTHORITY WAYLAND_DISPLAY"
          # "udiskie"
          "swww-daemon"
          "sosd daemon"
          "wallpaper -t 8h --no-allow-video -d -b -i ${inputs.wallpapers}"
        ];
        env = [ "XCURSOR_SIZE,24" "PATH,$HOME/.local/bin:$PATH" ];

        input = {
          kb_layout = "us";
          kb_variant = "";
          kb_model = "";
          kb_options = "";
          kb_rules = "";
          follow_mouse = true;
          numlock_by_default = true;
          scroll_method = "on_button_down";
          scroll_button = 274;
          touchpad = lib.mkIf gui.touchpad {
            natural_scroll = true;
            middle_button_emulation = true;
          };
          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
        };

        general = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          gaps_in = 3;
          gaps_out = 5;
          border_size = 0;
          layout = "dwindle";
        };

        misc = {
          disable_hyprland_logo = true;
          animate_manual_resizes = true;
          animate_mouse_windowdragging = true;
        };

        decoration = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          rounding = 5;
          drop_shadow = false;
          blur = {
            size = 10;
            passes = 2;
            noise = 0.0150;
          };
        };

        animations = {
          enabled = true;
          # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        plugin = {
          overview = {
            showEmptyWorkspace = true;
          };
        };

        windowrule = [
          #
          # Implementation
          #
          "float,zoom"

          "float,thunar"
          "float,dolphin"
          "float,sirula"

          #
          # Sbbw
          #
          # "float,^*sbbw*$"
          # "pin,^*sbbw*$"
          # "noblur,^*sbbw*$"
          # "noanim,^*sbbw*$"
          # "nofocus,^*sbbw*$"
          # "noshadow,^*sbbw*$"
          # "noborder,^*sbbw*$"
          #
          # Screen Share
          #
          "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
          "noanim,class:^(xwaylandvideobridge)$"
          "nofocus,class:^(xwaylandvideobridge)$"
          "noinitialfocus,class:^(xwaylandvideobridge)$"
          "noblur,class:^(google-chrome)$"
        ];

        dwindle = {
          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true; # you probably want this
        };

        master = {
          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          new_is_master = true;
        };

        gestures = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          workspace_swipe = true;
        };

        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        # l -> locked, will also work when an input inhibitor (e.g. a lockscreen) is active.
        # r -> release, will trigger on release of a key.
        # e -> repeat, will repeat when held.
        # n -> non-consuming, key/mouse events will be passed to the active window in addition to triggering the dispatcher.
        # m -> mouse, see below
        # t -> transparent, cannot be shadowed by other binds.
        # i -> ignore mods, will ignore modifiers.
        bindel = lib.lists.optionals sosdEnabled [
          #
          # Volume keybinds
          #
          ",XF86AudioRaiseVolume,exec,${sosdCmd} volume-up"
          ",XF86AudioLowerVolume,exec,${sosdCmd} volume-down"
          #
          # Brightness keys
          #
          ",XF86MonBrightnessUp,exec,${sosdCmd} brightness-up"
          ",XF86MonBrightnessDown,exec,${sosdCmd} brightness-down"
        ];

        # Move/resize windows with mainMod + LMB/RMB and dragging
        bindm = [
          "SUPER,mouse:272,movewindow"
          "SUPER,mouse:273,resizewindow"
        ];

        bind = [
          #
          # WM Keybinds
          #
          "SUPER,F,togglefloating,"
          "SUPER_SHIFT,F,fullscreen,"
          "SUPER,T,pseudo,"
          "SUPER,W,killactive,"
          # TODO: replace MOD+Q by power menu
          # "SUPER,Q,exit,"
          #
          # Custom Exec Keybinds
          #
          "SUPER,Return,exec,wezterm start"
          # "SUPER_SHIFT,Return,exec,st -A 0.75 -x 5 -s 'gruv-dark' -f 'FiraCode Nerd Font Mono' -z 17.0 -e fish"
          "SUPER,E,exec,cosmic-files"
          # "SUPER,D,exec,trilium"
          "SUPER,Tab,exec,anyrun"
          # "SUPER,Tab,overview:toggle," # Hyprspace plugin
          # "SUPER_SHIFT,Tab,exec,anyrun"
          # "SUPER,N,exec,${user.browser}"
          # "SUPER_SHIFT,N,exec,${user.browser} --private-window"
          "SUPER,S,exec,sss --area \"$(slurp -d)\" -o raw | wl-copy"
          "SUPER_SHIFT,S,exec,sss --area \"$(slurp -d)\" -o \"$HOME/Pictures/Screenshot/$(date '+%Y-%m-%d-%H%M%S')_sss.png\""
          "SUPER,ALT_S,exec,hyprshot --clipboard-only -m region"
          "SUPER_SHIFT,ALT_S,exec,hyprshot -m region -o ~/Pictures/Screenshot"

          "SUPER,C,exec,hyprpicker -a -f hex"
          #
          # Windows Navigations
          #
          "SUPER,H,movefocus,l"
          "SUPER,L,movefocus,r"
          "SUPER,K,movefocus,u"
          "SUPER,J,movefocus,d"
          "SUPER_SHIFT,H,movewindow,l"
          "SUPER_SHIFT,L,movewindow,r"
          "SUPER_SHIFT,K,movewindow,u"
          "SUPER_SHIFT,J,movewindow,d"
          #
          # Workspace Navigations
          #
          "SUPER,1,workspace,1"
          "SUPER,2,workspace,2"
          "SUPER,3,workspace,3"
          "SUPER,4,workspace,4"
          "SUPER,5,workspace,5"
          "SUPER,6,workspace,6"
          "SUPER,7,workspace,7"
          "SUPER,8,workspace,8"
          "SUPER,9,workspace,9"
          "SUPER,0,workspace,10"

          "SUPER_SHIFT,1,movetoworkspacesilent,1"
          "SUPER_SHIFT,2,movetoworkspacesilent,2"
          "SUPER_SHIFT,3,movetoworkspacesilent,3"
          "SUPER_SHIFT,4,movetoworkspacesilent,4"
          "SUPER_SHIFT,5,movetoworkspacesilent,5"
          "SUPER_SHIFT,6,movetoworkspacesilent,6"
          "SUPER_SHIFT,7,movetoworkspacesilent,7"
          "SUPER_SHIFT,8,movetoworkspacesilent,8"
          "SUPER_SHIFT,9,movetoworkspacesilent,9"
          "SUPER_SHIFT,0,movetoworkspacesilent,10"
        ] ++ lib.lists.optionals sosdEnabled [
          ",XF86AudioMute,exec,${sosdCmd} audio-mute-toggle"
          ",XF86AudioMicMute,exec,${sosdCmd} mic-mute-toggle"
          ",Caps_Lock,exec,sleep 1s && ${sosdCmd} caps-lock"
          ",Num_Lock,exec,sleep 1s && ${sosdCmd} num-lock"
        ];
      };
    };
  };
}
