{pkgs, ...}:
let 
    lualine-lsp-progress = pkgs.vimUtils.buildVimPlugin {
        pname = "lualine-lsp-progress.nvim";
        version = "2023-10-10";
        src = pkgs.fetchFromGitHub {
            owner = "WhoIsSethDaniel";
            repo = "lualine-lsp-progress.nvim";
            rev = "d76634e491076e45f465b31849d6ec320b436abb";
            sha256 = "";
        };
        meta.homepage = "https://github.com/WhoIsSethDaniel/lualine-lsp-progress.nvim";
    };
in {
    pkgs.vimPlugins.plugin = lualine-lsp-progress;
    pkgs.vimPlugins.type = "lua";
}
