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
            plugins = [
                pkgs.vimPlugins.nvim-treesitter.withAllGrammars
            ];
        };
    };
}
