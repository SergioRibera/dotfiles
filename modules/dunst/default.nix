{
    enable = true;
    iconTheme = {
        name = "Papirus-Light";
    };
    settings = {
        global = {
            monitor = 0;
            follow = "mouse";
            indicate_hidden = true;
            shrink = false;
            transparency = 25;
            notification_height = 0;
            separator_height = 2;
            padding = 24;
            horizontal_padding = 24;
            separator_color = "frame";
            sort = true;
            idle_threshold = 120;
            corner_radius = 5;
            font = "FiraCode Nerd Font 10";
            line_height = 4;
            markup = "full";
            format = "<b>%s</b>\n\n%b";
            alignment = "left";
            show_age_threshold = 60;
            word_wrap = true;
            ellipsize = "middle";
            ignore_newline = false;
            stack_duplicates = true;
            hide_duplicate_count = true;
            show_indicators = true;
            icon_position = "left";
            max_icon_size = 32;
            sticky_history = false;
            history_length = 20;
            dmenu = "rofi -p \"Notifications\" -dmenu -i";
            browser = "firefox --new-tab";
            always_run_script = true;
            title = "Dunst";
            class = "Dunst";
            startup_notification = false;
            verbosity = "mesg";
            force_xinerama = false;
            mouse_left_click = "do_action";
            mouse_middle_click = "close_all";
            mouse_right_click = "close_current";
            per_monitor_dpi = false;

            urgency_low = {
                frame_color = "#272a33";
                background = "#272a33";
                foreground = "#ffffff";
                timeout = 10;
            };
            
            urgency_normal = {
                frame_color = "#272a33";
                background = "#272a33";
                foreground = "#ffffff";
                timeout = 10;
            };
            
            urgency_critical = {
                frame_color = "#272a33";
                background = "#272a33";
                foreground = "#ffffff";
                timeout = 0;
            };
        };
    };
}
