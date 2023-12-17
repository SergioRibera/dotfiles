{ pkgs, ... }: {
    enable = true;
    style = builtins.readFile ./theme.rasi;
    settings = {
        location = "center";
        width = 640;
    };
}
