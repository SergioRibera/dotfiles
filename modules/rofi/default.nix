{ pkgs, ... }: {
    enable = true;
    font = "mono 12";
    plugins = with pkgs; [ rofi-calc rofi-bluetooth ];
    theme = ./theme.rasi;
    extraConfig = {
        modi = "window,drun,run,calc";
        fixed-num-lines = true;
        show-icons = true;
        drun-match-fields = "name,generic,exec,categories,keywords";
        drun-display-format = "{name} [<span weight='light' size='small'><i>({generic})</i></span>]";
        drun-url-launcher = "xdg-open";
        disable-history = false;
        ignored-prefixes = "";
        sort = false;
        case-sensitive = false;
        cycle = true;
        sidebar-mode = false;
        combi-modi = "window,drun,run,calc";
        matching = "normal";
        tokenize = true;
        scroll-method = 0;
        window-format = "{w}    {c}   {t}";
        click-to-exit = true;
        kb-mode-complete = "Alt+l";
        kb-row-up = "Up,Ctrl+k,Shift+Tab,Shift+ISO_Left_Tab";
        kb-row-down = "Down,Ctrl+j";
        kb-accept-entry = "Ctrl+m,Return,KP_Enter";
        terminal = "mate-terminal";
        kb-remove-to-eol = "Ctrl+Shift+e";
        kb-mode-next = "Shift+Right,Ctrl+Tab,Ctrl+l";
        kb-mode-previous = "Shift+Left,Ctrl+Shift+Tab,Ctrl+h";
        kb-remove-char-back = "BackSpace";
    };
}
