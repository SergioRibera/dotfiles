{pkgs, ...}: {
    programs = {
        fish.enable = true;
        thunar.enable = true;
        obs-studio.enable = true;

        hyprland = {
            enable = true;
            xwayland = {
                enable = true;
            };
        };

        neovim = {
            enable = true;
            defaultEditor = true;
            viAlias = true;
            vimAlias = true;
            vimdiffAlias = true;
        };
    };
}
