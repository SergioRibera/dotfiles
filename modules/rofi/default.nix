{ pkgs, ... }: {
    enable = true;
    font = "mono 12";
    plugins = with pkgs; [ rofi-calc rofi-bluetooth ];
    theme = ./theme.rasi;
}
