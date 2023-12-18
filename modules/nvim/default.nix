{pkgs, ...}:
let
    cfg = import ./plugins {inherit pkgs;};
in
{
    programs.neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        plugins = with pkgs.vimPlugins; [
            # Color
            nvim-base16
            nvim-colorizer-lua
            nvim-treesitter.withAllGrammars
            nvim-ts-rainbow2
            # completion
            neogen
            cmp-path
            cmp-buffer
            cmp-cmdline
            cmp-nvim-lsp
            cmp-nvim-lsp-signature-help
            # Snippets
            luasnip
            cmp_luasnip
            friendly-snippets
            # LSP
            crates-nvim
            trouble-nvim   # show diagnostics
            nvim-lspconfig # lsp configs
            lspkind-nvim   # icons for lsp
            nvim-comment   # manage comment code with keymaps
            # status bar
            nvim-navic
            lsp-status-nvim
            lualine-nvim
            # Editor
            nvim-ufo
            nvim-autopairs
            nvim-surround
            promise-async
            nvim-tree-lua
            nvim-web-devicons
            cheatsheet-nvim
            # UI
            telescope-nvim
            telescope-media-files-nvim
            telescope-file-browser-nvim
            telescope-ui-select-nvim
            popup-nvim
            # Debug
            # just println! xd
            # nvim-dap
            # nvim-dap-ui
            # nvim-dap-virtual-text
            #
            # Extras
            plenary-nvim
            twilight-nvim
            nvim-notify
            # git
            gitsigns-nvim
            # misc
            vim-wakatime
            presence-nvim
            # instant-nvim # no one I work with uses nvim so it makes no sense
            dial-nvim
        ] ++ cfg.plugins;
    };
}
