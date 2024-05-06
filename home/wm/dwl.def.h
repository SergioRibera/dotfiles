// XF86XK_* from: https://cgit.freedesktop.org/xorg/proto/x11proto/tree/XF86keysym.h
#define XF86XK_MonBrightnessUp   0x1008FF02  /* Monitor/panel brightness */
#define XF86XK_MonBrightnessDown 0x1008FF03  /* Monitor/panel brightness */

#define XF86XK_AudioLowerVolume	0x1008FF11   /* Volume control down        */
#define XF86XK_AudioMute	0x1008FF12   /* Mute sound from the system */
#define XF86XK_AudioRaiseVolume	0x1008FF13   /* Volume control up          */
#define XF86XK_AudioPlay	0x1008FF14   /* Start playing of audio >   */
#define XF86XK_AudioStop	0x1008FF15   /* Stop playing audio         */
#define XF86XK_AudioPrev	0x1008FF16   /* Previous track             */
#define XF86XK_AudioNext	0x1008FF17   /* Next track                 */
#define Key_Caps_Lock     66
#define Key_Num_Lock      77

#define XF86XK_AudioMicMute	0x1008FFB2   /* Mute the Mic from the system */


/* Taken from https://github.com/djpohly/dwl/issues/466 */
#define COLOR(hex)    { ((hex >> 24) & 0xFF) / 255.0f, \
                        ((hex >> 16) & 0xFF) / 255.0f, \
                        ((hex >> 8) & 0xFF) / 255.0f, \
                        (hex & 0xFF) / 255.0f }
/* appearance */
static const int sloppyfocus               = 1;  /* focus follows mouse */
static const int bypass_surface_visibility = 0;  /* 1 means idle inhibitors will disable idle tracking even if it's surface isn't visible  */
static const unsigned int borderpx         = 0;  /* border pixel of windows */
static const float rootcolor[]             = COLOR(0x222222ff);
static const float bordercolor[]           = COLOR(0x444444ff);
static const float focuscolor[]            = COLOR(0x005577ff);
static const float urgentcolor[]           = COLOR(0xff0000ff);
/* This conforms to the xdg-protocol. Set the alpha to zero to restore the old behavior */
static const float fullscreen_bg[]         = COLOR(0x000000ff); /* You can also use glsl colors */
static const char cursortheme[]            = "@cursortheme@";
static const unsigned int cursorsize       = @cursorsize@;

/* SceneFX */
// Style
// "opacity 0.90,[Tt]hunar"
// "opacity 0.70,^*osd*$"
static const int opacity = 1; /* flag to enable opacity */
static const float opacity_inactive = 0.8;
static const float opacity_active = 1.0;

static const int shadow = 0; /* flag to enable shadow */
static const int shadow_only_floating = 0; /* only apply shadow to floating windows */
static const struct wlr_render_color shadow_color = COLOR(0x0000FFff);
static const struct wlr_render_color shadow_color_focus = COLOR(0xFF0000ff);
static const int shadow_blur_sigma = 20;
static const int shadow_blur_sigma_focus = 40;
static const char *const shadow_ignore_list[] = { NULL }; /* list of app-id to ignore */

static const int corner_radius = @round@; /* 0 disables corner_radius */

static const int blur = 1; /* flag to enable blur */
static const int blur_optimized = 1;
static const int blur_ignore_transparent = 1;
static const struct blur_data blur_data = {
	.radius = 10,
	.num_passes = 2,
	.noise = 0.0150,
	.brightness = 0.9,
	.contrast = 0.9,
	.saturation = 1.1,
};


/* tagging - TAGCOUNT must be no greater than 31 */
#define TAGCOUNT (10)

/* logging */
static int log_level = WLR_ERROR;

/* Autostart */
static const char *const autostart[] = {
  "sh", "-c", "dbus-update-activation-environment DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP", NULL,
  // "dbus-update-activation-environment DISPLAY XAUTHORITY WAYLAND_DISPLAY", NULL,
  // "udiskie", NULL,
  "thunar --daemon", NULL,
  "swww-daemon", NULL,
  "wallpaper -t 8h --no-allow-video -d -b -i \"@wallpapers@\"", NULL,
  NULL /* terminate */
};

static const Rule rules[] = {
	/* app_id                   title      tags mask     isfloating   monitor */
	{ "zoom",                    NULL,       0,            1,           -1 },
	{ "thunar",                  NULL,       0,            1,           -1 },
	{ "gnome-font-viewer",       NULL,       0,            1,           -1 },
	{ "pavucontrol",             NULL,       0,            1,           -1 },
	{ "^thunar$",                NULL,       0,            1,           -1 },
	{ "^Thunar$",                NULL,       0,            1,           -1 },
	{ "xdg-desktop-portal-gtk",  NULL,       0,            1,           -1 },
	{ "xwaylandvideobridge",     NULL,       1 << 9,       1,           -1 },
	{ NULL, ".com is sharing your screen.$", 1 << 9,       1,           -1 },

	{ "google-chrome",           NULL,       1 << 0,       0,           -1 },
	{ "Slack",                   NULL,       1 << 3,       0,           -1 },
	{ "discord",                 NULL,       1 << 3,       0,           -1 },
	{ "discord",    "Discord Updater",       1 << 3,       1,           -1 },
};

/* layout(s) */
static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },
	{ "TTT",      bstack },
	{ "[M]",      monocle },
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{  NULL,      NULL },
};

/* monitors */
/* NOTE: ALWAYS add a fallback rule, even if you are completely sure it won't be used */
// https://wayland.freedesktop.org/docs/html/apa.html#protocol-spec-wl_output-enum-transform
static const MonitorRule monrules[] = {
  /* name       mfact nmaster scale layout       rotate/reflect              x     y     resx  resy rate  mode adaptive*/
  /* defaults */
  { "eDP-1",    0.55f, 1,      1,  &layouts[0], WL_OUTPUT_TRANSFORM_NORMAL,  1080, 1020, 1600,  900, 60.0f, 0,   1 },
                                                /* 270 degrees clockwise */
  { "HDMI-A-1", 0.55f, 1,      1,  &layouts[0],                          3,     0,    0, 1080, 1920, 60.0f, 0,   1 },
  { NULL,       0.55f, 1,      1,  &layouts[0], WL_OUTPUT_TRANSFORM_NORMAL,     0,    0,    0,    0,  0.0f, 0,   1 },
  // mode let's the user decide on how dwl should implement the modes:
  // -1 Sets a custom mode following the users choice
  // All other number's set the mode at the index n, 0 is the standard mode; see wlr-randr
};

/* keyboard */
static const struct xkb_rule_names xkb_rules = {
	/* can specify fields: rules, model, layout, variant, options */
	/* example:
	.options = "ctrl:nocaps",
	*/
	.options = NULL,
};

static const int repeat_rate = 25;
static const int repeat_delay = 600;

/* Trackpad */
static const int tap_to_click = 1;
static const int tap_and_drag = 1;
static const int drag_lock = 1;
static const int natural_scrolling = 1;
static const int disable_while_typing = 1;
static const int left_handed = 0;
static const int middle_button_emulation = 1;
/* You can choose between:
LIBINPUT_CONFIG_SCROLL_NO_SCROLL
LIBINPUT_CONFIG_SCROLL_2FG
LIBINPUT_CONFIG_SCROLL_EDGE
LIBINPUT_CONFIG_SCROLL_ON_BUTTON_DOWN
*/
static const enum libinput_config_scroll_method scroll_method = LIBINPUT_CONFIG_SCROLL_2FG;

/* You can choose between:
LIBINPUT_CONFIG_CLICK_METHOD_NONE
LIBINPUT_CONFIG_CLICK_METHOD_BUTTON_AREAS
LIBINPUT_CONFIG_CLICK_METHOD_CLICKFINGER
*/
static const enum libinput_config_click_method click_method = LIBINPUT_CONFIG_CLICK_METHOD_CLICKFINGER;

/* You can choose between:
LIBINPUT_CONFIG_SEND_EVENTS_ENABLED
LIBINPUT_CONFIG_SEND_EVENTS_DISABLED
LIBINPUT_CONFIG_SEND_EVENTS_DISABLED_ON_EXTERNAL_MOUSE
*/
static const uint32_t send_events_mode = LIBINPUT_CONFIG_SEND_EVENTS_ENABLED;

/* You can choose between:
LIBINPUT_CONFIG_ACCEL_PROFILE_FLAT
LIBINPUT_CONFIG_ACCEL_PROFILE_ADAPTIVE
*/
static const enum libinput_config_accel_profile accel_profile = LIBINPUT_CONFIG_ACCEL_PROFILE_ADAPTIVE;
static const double accel_speed = 0.0;

/* You can choose between:
LIBINPUT_CONFIG_TAP_MAP_LRM -- 1/2/3 finger tap maps to left/right/middle
LIBINPUT_CONFIG_TAP_MAP_LMR -- 1/2/3 finger tap maps to left/middle/right
*/
static const enum libinput_config_tap_button_map button_map = LIBINPUT_CONFIG_TAP_MAP_LRM;

/* If you want to use the windows key for MODKEY, use WLR_MODIFIER_LOGO */
#define MODKEY WLR_MODIFIER_LOGO
#define MOD_ALT WLR_MODIFIER_ALT
#define MOD_CONTROL WLR_MODIFIER_CTRL
#define MOD_SHIFT WLR_MODIFIER_SHIFT
#define MOD_LOGO WLR_MODIFIER_LOGO
#define MOD_NONE 0

#define TAGKEYS(KEY,TAG) \
	{ MODKEY,  KEY,                      view,       {.ui = 1 << TAG} }, \
	{ MODKEY|MOD_SHIFT, KEY,             tag,        {.ui = 1 << TAG} },
	// { MODKEY|MOD_CONTROL, KEY,           toggleview, {.ui = 1 << TAG} }, \
	// { MODKEY|MOD_CONTROL|MOD_SHIFT, KEY, toggletag,  {.ui = 1 << TAG} }

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

static const Gesture gestures[] = {
  /* modifier  gesture       fingers_count   function    argument */
  { MOD_NONE,         SWIPE_LEFT,   3,              shiftview,  { .i = 1 } },
  { MOD_NONE,         SWIPE_RIGHT,  3,              shiftview,  { .i = -1 } },
  // Swipe down to kill app
  // { MOD_NONE,         SWIPE_DOWN,  3,              shiftview,  { .i = -1 } },
};

// TODO: configure keymaps
static const Key keys[] = {
	/* Note that Shift changes certain key codes: c -> C, 2 -> at, etc. */
	/* modifier                  key                 function        argument */

  // ### MEDIA KEYBINDINGS
  { MOD_NONE,               XF86XK_AudioRaiseVolume,  spawn,        SHCMD("swayosd --output-volume raise") },
  { MOD_NONE,               XF86XK_AudioLowerVolume,  spawn,        SHCMD("swayosd --output-volume lower") },
  { MOD_NONE,               XF86XK_AudioMute,exec,    spawn,        SHCMD("swayosd --output-volume mute-toggle") },
  { MOD_NONE,               XF86XK_AudioMicMute,      spawn,        SHCMD("swayosd --input-volume mute-toggle") },

  { MOD_NONE,             XF86XK_MonBrightnessUp,     spawn,       SHCMD("swayosd --brightness raise") },
  { MOD_NONE,             XF86XK_MonBrightnessDown,   spawn,       SHCMD("swayosd --brightness lower") },

  // TODO: capslock and numlock
  { MOD_NONE,             Key_Caps_Lock,              spawn,       SHCMD("swayosd --caps-lock") },
  { MOD_NONE,             Key_Num_Lock,               spawn,       SHCMD("swayosd --num-lock") },

  { MODKEY,                    XKB_KEY_Return,     spawn,          SHCMD("wezterm start")}
  { MODKEY|MOD_SHIFT,          XKB_KEY_Return,     spawn,          SHCMD("wezterm start -- fish --private")}
	{ MODKEY,                    XKB_KEY_w,          killclient,     {0} },
	{ MODKEY,                    XKB_KEY_j,          focusstack,     {.i = +1} },
	{ MODKEY,                    XKB_KEY_k,          focusstack,     {.i = -1} },
	// { MODKEY,                    XKB_KEY_Return,     zoom,           {0} },
	{ MODKEY,                    XKB_KEY_e,          spawn,           SHCMD("thunar") },
	{ MODKEY,                    XKB_KEY_Tab,        spawn,           SHCMD("anyrun") },
	{ MODKEY,                    XKB_KEY_s,          spawn,           SHCMD("hyprshot --clipboard-only -m region") },
	{ MODKEY|MOD_SHIFT,          XKB_KEY_s,          spawn,           SHCMD("hyprshot -m region -o ~/Pictures/Screenshot") },
	{ MODKEY,                    XKB_KEY_c,          spawn,           SHCMD("hyprpicker -a -f hex") },

  // TODO: look
	{ MODKEY,                    XKB_KEY_t,          setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                    XKB_KEY_f,      togglefloating,     {0} },
	{ MODKEY|MOD_SHIFT,          XKB_KEY_F,    togglefullscreen,     {0} },
  TAGKEYS( XKB_KEY_1, 1),
  TAGKEYS( XKB_KEY_2, 2),
  TAGKEYS( XKB_KEY_3, 3),
  TAGKEYS( XKB_KEY_4, 4),
  TAGKEYS( XKB_KEY_5, 5),
  TAGKEYS( XKB_KEY_6, 6),
  TAGKEYS( XKB_KEY_7, 7),
  TAGKEYS( XKB_KEY_8, 8),
  TAGKEYS( XKB_KEY_9, 9),
	// { MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_Q,          quit,           {0} },

	/* Ctrl-Alt-Fx is used to switch to another VT, if you don't know what a VT is
	 * do not remove them.
	 */
#define CHVT(n) { WLR_MODIFIER_CTRL|WLR_MODIFIER_ALT,XKB_KEY_XF86Switch_VT_##n, chvt, {.ui = (n)} }
	CHVT(1), CHVT(2), CHVT(3), CHVT(4), CHVT(5), CHVT(6),
	CHVT(7), CHVT(8), CHVT(9), CHVT(10), CHVT(11), CHVT(12),
};

static const Button buttons[] = {
	{ MODKEY, BTN_LEFT,   moveresize,     {.ui = CurMove} },
  { MODKEY, BTN_MIDDLE, moveresize,     {.ui = Curmfact} },
	{ MODKEY, BTN_RIGHT,  moveresize,     {.ui = CurResize} },
};
