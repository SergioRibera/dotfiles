local wezterm = require("wezterm")

return {

    disable_default_key_bindings = true,

    mouse_bindings = {
        {
            event = { Up = { streak = 1, button = "Left" } },
            mods = "CTRL",
            action = "OpenLinkAtMouseCursor",
        },
    },

    keys = {
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
        { key = "x", mods = "CTRL|SHIFT", action = "ActivateCopyMode" },
        { key = "v", mods = "CTRL|SHIFT", action = wezterm.action {PasteFrom = "Clipboard"} },
        { key = "c", mods = "CTRL|SHIFT", action = wezterm.action {CopyTo = "ClipboardAndPrimarySelection"} }
    }
}
