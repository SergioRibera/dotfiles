local wezterm = require("wezterm")

return {

    disable_default_key_bindings = true,

    keys = {
        { key = "Enter", mods = "CTRL|SHIFT", action = "SpawnWindow" },
        -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
        {key="LeftArrow", mods="OPT", action=wezterm.action{SendString="\x1bb"}},
        -- Make Option-Right equivalent to Alt-f; forward-word
        {key="RightArrow", mods="OPT", action=wezterm.action{SendString="\x1bf"}},
        -- Open mew tab
        { key = "t", mods = "CTRL", action = wezterm.action {SpawnTab = "CurrentPaneDomain"} },
        -- Close current Tab or window
        { key = "w", mods = "CTRL|SHIFT", action = wezterm.action {CloseCurrentTab = {confirm = false}} },
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
