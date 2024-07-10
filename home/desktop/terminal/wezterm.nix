{ config, lib, ... }: let
  toLuaArr = arr: "{ " + (lib.strings.concatMapStringsSep ", " (i: "'${i}'") arr) + " }";
  privCmdLua = toLuaArr config.shell.privSession;
in {
  home-manager.users.${config.user.username}.programs.wezterm = {
    enable = true;
    colorSchemes = {
      custom = {
        background = "#232627";
        foreground = "#fcfcfc";
        cursor_bg = "#a3b8ef";
        cursor_fg = "#a3b8ef";
        cursor_border = "#a3b8ef";
        split = "#3b4b58";
        selection_fg = "#2a2e38";
        selection_bg = "#979eab";
        ansi = [
          "#71798a"
          "#d19a66"
          "#56b6c2"
          "#e5c07b"
          "#61afef"
          "#be5046"
          "#56b6c2"
          "#abb2bf"
        ];

        brights = [
          "#2a2e38"
          "#ed1515"
          "#1cdc9a"
          "#f67400"
          "#1d99f3"
          "#9b59b6"
          "#1abc9c"
          "#fcfcfc"
        ];
      };
    };
    extraConfig = ''
      local wezterm = require("wezterm")

      return {
          -- OpenGL for GPU acceleration, Software for CPU
          front_end = "OpenGL",
          -- No updates
          check_for_updates = false,
          -- Wayland
          enable_wayland = true,
          -- Get rid of close prompt
          window_close_confirmation = "NeverPrompt",

          -- Cursor style
          default_cursor_style = "BlinkingBar",

          window_background_opacity = 0.7,
          -- Basic font configuration
          font = wezterm.font_with_fallback {
              'CaskaydiaCove Nerd Font',
              'FiraCode Nerd Font',
              'UbuntuMono Nerd Font',
              'Noto Color Emoji',
          },
          font_size = 12.0,
          font_shaper = "Harfbuzz",
          line_height = 1.0,
          freetype_load_target = "HorizontalLcd",
          freetype_render_target = "HorizontalLcd",

          color_scheme = "custom",
          bold_brightens_ansi_colors = true,
          window_padding = {left = 0, right = 0, top = 0, bottom = 0},
          inactive_pane_hsb = {saturation = 1.0, brightness = 1.0},

          -- Tab Options
          enable_tab_bar = false,
          tab_bar_at_bottom = false,
          hide_tab_bar_if_only_one_tab = true,
          show_tab_index_in_tab_bar = false,

          -- Keybinds
          disable_default_key_bindings = true,
          mouse_bindings = {
              {
                  event = { Up = { streak = 1, button = "Left" } },
                  mods = "CTRL",
                  action = "OpenLinkAtMouseCursor",
              },
          },
          keys = {
              { key = "n", mods = "CTRL|SHIFT", action = wezterm.action.SplitPane {
                  direction = 'Down',
                  top_level = true,
                  command = { args = ${privCmdLua} }
              } },
              { key = "l", mods = "CTRL|SHIFT", action = wezterm.action{ SplitHorizontal={ domain="CurrentPaneDomain" } } },
              { key = "h", mods = "CTRL|SHIFT", action = wezterm.action{ SplitVertical={ domain="CurrentPaneDomain" } } },
              { key = "LeftArrow", mods = "CTRL", action = { SendKey = { key = "b", mods = "ALT"} } },
              { key = "RightArrow", mods = "CTRL", action = { SendKey = { key = "f", mods = "ALT"} } },
              -- Open mew tab
              { key = "t", mods = "CTRL", action = wezterm.action {SpawnTab = "CurrentPaneDomain"} },
              -- Close current Tab or window
              { key = "w", mods = "CTRL|SHIFT", action = wezterm.action {CloseCurrentPane = {confirm = false}} },
              -- Go to next tab
              { mods = "CTRL", key = "Tab", action = wezterm.action {ActivateTabRelative = 1} },
              -- Go to previous tab
              { mods = "CTRL|SHIFT", key = "Tab", action = wezterm.action {ActivateTabRelative = -1} },
              -- standard copy/paste bindings
              { key = "v", mods = "CTRL|SHIFT", action = wezterm.action {PasteFrom = "Clipboard"} },
              { key = "c", mods = "CTRL|SHIFT", action = wezterm.action {CopyTo = "ClipboardAndPrimarySelection"} }
          }
      }
    '';
  };
}
