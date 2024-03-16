{ pkgs, ... }: {
    enable = true;
    extraPackages = with pkgs.bat-extras; [ batman batpipe batdiff batgrep batwatch prettybat ];
    config = {
        map-syntax = [
            "*.jenkinsfile:Groovy"
            "*.props:Java Properties"
        ];
        pager = "less -FR";
        theme = "gruvbox-dark";
        style = "header-filename,header-filesize,rule,numbers,snip,changes,header";
    };
}
