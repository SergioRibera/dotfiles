{ inputs, config, lib, ... }: let
  inherit (config) gui user terminal shell wm services;

  floatToIntStr = v: lib.replaceStrings [".000000"] [""] (toString v);
  sosdEnabled = config.home-manager.users.${user.username}.programs.sosd.enable;

  join = builtins.concatStringsSep;
  mkRotation = r: if r == "left" then 3 else if r == "right" then 1 else if r == "inverted" then 2 else 0;
in {
  imports = [
    inputs.mango.nixosModules.mango
  ];
  home-manager.users.${user.username} = lib.mkIf (user.enableHM) ({ ...}: {
    imports = [
      inputs.mango.hmModules.mango
    ];

    wayland.windowManager.mango = {
      enable = gui.enable && (builtins.elem "mango" wm.actives);
      autostart_sh = ''
        dbus-update-activation-environment --all
        swww-daemon &
        sosd daemon &
        ${user.homepath}/.local/bin/wallpaper -t 8h --no-allow-video -d -b -i ${inputs.wallpapers} &
      '';
      settings = ''
# Window effect
blur=1
blur_layer=0
blur_optimized=1
blur_params_num_passes = 2
blur_params_radius = 10
blur_params_noise = 0.0150
blur_params_brightness = 0.9
blur_params_contrast = 0.9
blur_params_saturation = 1.2

shadows = 0
layer_shadows = 0
shadow_only_floating = 1
shadows_size = 10
shadows_blur = 15
shadows_position_x = 0
shadows_position_y = 0
shadowscolor= 0x000000ff

border_radius=8
no_radius_when_single=0
focused_opacity=1.0
unfocused_opacity=1.0

# Animation Configuration(support type:zoom,slide,fade,none)
# tag_animation_direction: 0-horizontal,1-vertical
animations=1
layer_animations=0
animation_type_open=zoom
animation_type_close=fade
animation_fade_in=1
animation_fade_out=1
tag_animation_direction=1
zoom_initial_ratio=0.2
zoom_end_ratio=0.4
fadein_begin_opacity=0.2
fadeout_begin_opacity=0.4
animation_duration_move=200
animation_duration_open=200
animation_duration_tag=250
animation_duration_close=200
animation_curve_open=0.46,1.0,0.29,1
animation_curve_move=0.46,1.0,0.29,1
animation_curve_tag=0.46,1.0,0.29,1
animation_curve_close=0.08,0.92,0,1

# Scroller Layout Setting
scroller_structs=20
scroller_default_proportion=1.0
scroller_focus_center=0
scroller_prefer_center=0
edge_scroller_pointer_focus=1
scroller_default_proportion_single=1.0
scroller_proportion_preset=1.0

# Master-Stack Layout Setting (tile,spiral,dwindle)
new_is_master=0
default_mfact=0.55
default_nmaster=1
smartgaps=0

# Overview Setting
enable_hotarea=1
hotarea_size=10
ov_tab_mode=0
overviewgappi=5
overviewgappo=30

# Misc
no_border_when_single=0
axis_bind_apply_timeout=100
focus_on_activate=1
inhibit_regardless_of_visibility=0
sloppyfocus=1
warpcursor=1
focus_cross_monitor=0
focus_cross_tag=0
enable_floating_snap=0
snap_distance=30
cursor_theme=${gui.cursor.name}
cursor_size=${toString gui.cursor.size}
drag_tile_to_tile=1

# keyboard
repeat_rate=25
repeat_delay=600
numlockon=1
xkb_rules_layout=${services.xserver.xkb.layout}
xkb_rules_variant=${services.xserver.xkb.variant}

# Trackpad
# need relogin to make it apply
disable_trackpad=0
tap_to_click=1
tap_and_drag=1
drag_lock=1
trackpad_natural_scrolling=0
disable_while_typing=1
left_handed=0
middle_button_emulation=0
swipe_min_threshold=1

# mouse
# need relogin to make it apply
mouse_natural_scrolling=0

# Appearance
gappih=5
gappiv=5
gappoh=10
gappov=10
scratchpad_width_ratio=0.8
scratchpad_height_ratio=0.9
borderpx=0
rootcolor=0x201b14ff
bordercolor=0x444444ff
focuscolor=0xc9b890ff
maxmizescreencolor=0x89aa61ff
urgentcolor=0xad401fff
scratchpadcolor=0x516c93ff
globalcolor=0xb153a7ff
overlaycolor=0x14a57cff

# layout support:
# https://github.com/DreamMaoMao/mangowc/wiki#support-layout_name
# horizontal: tile scroller monocle grid dwindle spiral deck
# vertical: vertical_tile vertical_scroller vertical_monocle vertical_grid vertical_dwindle vertical_spiral vertical_deck
tagrule=id:1,layout_name:scroller
tagrule=id:2,layout_name:scroller
tagrule=id:3,layout_name:scroller
tagrule=id:4,layout_name:scroller
tagrule=id:5,layout_name:scroller
tagrule=id:6,layout_name:scroller
tagrule=id:7,layout_name:scroller
tagrule=id:8,layout_name:scroller
tagrule=id:9,layout_name:scroller

# no blur slurp select layer
layerrule=noblur:1,layer_name:selection
layerrule=noanim:1,noblur:1,layer_name:swww-daemon
layerrule=noanim:1,noblur:1,layer_name:__sosd_*

# https://github.com/DreamMaoMao/mangowc/wiki#window-rules
windowrule=isopensilent:1,appid:com.obsproject.Studio


${join "\n" (builtins.map (o:
  "monitorrule=${o.name},0.55,1,scroller,${toString (mkRotation o.rotation)},${floatToIntStr o.scale},${toString o.position.x},${toString o.position.y},${toString o.resolution.x},${toString o.resolution.y},${floatToIntStr o.frequency}"
) wm.screens)}

# Key Bindings
# key name refer to `xev` or `wev` command output,
# mod keys name: super,ctrl,alt,shift,none

# bind="SUPER,s,screenshot-window { write-to-disk = false; }
# bind="SUPER+Print,screenshot-window
# bind="SUPER+Shift,s,screenshot

bind=SUPER,Tab,spawn,sherlock
bind=SUPER,e,spawn,cosmic-files
bind=SUPER,Return,spawn,${join " " terminal.command} ${join " " shell.command}
bind=SUPER+SHIFT,Return,spawn,${join " " terminal.command} ${join " " shell.privSession}
bind=SUPER,b,spawn,nu ${user.homepath}/.config/eww/scripts/extras.nu toggle sidebar
bind=SUPER,p,spawn,nu ${user.homepath}/.config/eww/scripts/extras.nu toggle power-screen
bind=SUPER,m,spawn,nu ${user.homepath}/.config/eww/scripts/extras.nu toggle screenkey
${lib.optionalString sosdEnabled "bind=SUPER,y,spawn,nu ${user.homepath}/.local/bin/osd.nu show-time"}
bind=SUPER,c,spawn,hyprpicker -a -f hex
bind=SUPER,period,spawn,simplemoji -t medium-light -soc wl-copy

bind=SUPER,w,killclient
bind=SUPER,f,togglefloating
bind=SUPER+Shift,f,togglefullscreen

bind=SUPER,comma,setlayout,vertical_scroller
bind=SUPER,semicolon,setlayout,scroller

bind=SUPER,h,focusdir,left
bind=SUPER,l,focusdir,right
bind=SUPER,j,focusdir,down
bind=SUPER,k,focusdir,up

bind=SUPER+Shift,h,exchange_client,left
bind=SUPER+Shift,l,exchange_client,right
bind=SUPER+Shift,j,exchange_client,down
bind=SUPER+Shift,k,exchange_client,up

# Mouse Button Bindings
# NONE mode key only work in ov mode
mousebind=SUPER,btn_left,moveresize,curmove
mousebind=SUPER,btn_right,moveresize,curresize
      '';
    };
  });
}
