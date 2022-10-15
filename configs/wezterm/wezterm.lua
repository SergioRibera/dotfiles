local wezterm = require("wezterm")
local mytable = require("lib/mystdlib").mytable
local mycolors = require("colors")
local gui = require('gui')
local success, stdout, _ = wezterm.run_child_process({"echo", "$XDG_CURRENT_DESKTOP"});

local fonts = {
    -- Basic font configuration
    font_size = 12.0,
    font_shaper = "Harfbuzz",
    line_height = 1.0,
    freetype_load_target = "HorizontalLcd",
    freetype_render_target = "HorizontalLcd",
}

local style = {
    -- Cursor style
    default_cursor_style = "BlinkingBar",

    -- window_background_opacity = 0.7,

    -- Bright bold colors
    bold_brightens_ansi_colors = true,
    -- Padding
    window_padding = {left = 0, right = 0, top = 0, bottom = 0},

    -- Opacity
    inactive_pane_hsb = {saturation = 1.0, brightness = 1.0},

    colors = mycolors,
}

if success and stdout ~= 'Hyprland' then
    style.window_background_opacity = 0.7
end

local base = {

    -- OpenGL for GPU acceleration, Software for CPU
    front_end = "OpenGL",

    -- No updates
    check_for_updates = false,

    -- Wayland
    enable_wayland = false,

    -- Get rid of close prompt
    window_close_confirmation = "NeverPrompt",

    ratelimit_output_bytes_per_second = 10000000,
}

-- Tab Style (like shape)
local tabs = gui.tabs

-- Keys
local keys = gui.keys

-- Merge everything and return
local config = mytable.merge_all(base, fonts, style, tabs, keys)
return config
