{ gui, lib }: {
  enable = true;
  xwayland.enable = true;
  settings = {
    monitor = [ "eDP-1,1600x900@60,1080x1020,1" "HDMI-A-1,1920x1080@60,0x0,1,transform,3" ];
    workspace = [ "eDP-1,10" "HDMI-A-1,10" ];
    exec-once = [
      "dbus-update-activation-environment DISPLAY XAUTHORITY WAYLAND_DISPLAY"
      "udiskie"
      "thunar --daemon"
      "swww init"
      "wallpaper -t 8h --no-allow-video -d -b"
      "hyprctl dispatcher focusmonitor 1"
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

    windowrule = [
      #
      # Implementation
      #
      "float,zoom"

      "float,thunar"
      "float,dolphin"
      "float,sirula"

      "workspace 5,[Dd]iscord"

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

      #
      # Style
      #
      "opacity 0.90,[Cc]ode"
      "opacity 0.90,[Tt]hunar"
      "opacity 0.90,org.wezfurlong.wezterm"
      "opacity 0.90,[Dd]iscord"
      "opacity 0.70,^*rofi*$"
      "opacity 0.70,^*osd*$"
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
    binde = [ ];
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
      "SUPER,E,exec,thunar"
      # "SUPER,D,exec,trilium"
      "SUPER,Tab,exec,pkill .anyrun-wrapped || run-as-service anyrun"
      "SUPER_SHIFT,Tab,exec,rofi -show drun"
      "SUPER,N,exec,firefox"
      "SUPER_SHIFT,N,exec,firefox --private-window"
      "SUPER,S,exec,hyprshot --clipboard-only -m region"
      "SUPER_SHIFT,S,exec,hyprshot -m region -o ~/Pictures/Screenshot"
      "SUPER,P,exec,~/.config/rofi/scripts/proyects.sh"
      "SUPER,C,exec,hyprpicker -a -f hex"
      #
      # Volume keybinds
      #
      ",XF86AudioRaiseVolume,exec,swayosd --output-volume raise"
      ",XF86AudioLowerVolume,exec,swayosd --output-volume lower"
      ",XF86AudioMute,exec,swayosd --output-volume mute-toggle"
      ",XF86AudioMicMute,exec,swayosd --input-volume mute-toggle"
      #
      # Brightness keys
      #
      ",XF86MonBrightnessUp,exec,swayosd --brightness raise"
      ",XF86MonBrightnessDown,exec,swayosd --brightness lower"
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
    ];
  };
}
