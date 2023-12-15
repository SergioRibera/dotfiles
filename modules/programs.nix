{pkgs, ...}: {
    programs = {
        fish.enable = true;
        thunar.enable = true;
        obs-studio.enable = true;

        hyprland = {
            enable = true;
        };

        neovim = {
            enable = true;
            defaultEditor = true;
            viAlias = true;
            vimAlias = true;
            vimdiffAlias = true;
            plugins = with pkgs.vimPlugins; [
                nvim-treesitter.withAllGrammars
            ];
        };
    };
}
