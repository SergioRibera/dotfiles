{ pkgs, ... }: {
    enable = true;
    theme = builtins.readFile ./theme.rasi;
    settings = {
        location: "center";
        width: 640;
    };
}
