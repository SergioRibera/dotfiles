{pkgs, ...}:
let 
    lualine-lsp-progress = pkgs.vimUtils.buildVimPlugin {
        pname = "lualine-lsp-progress.nvim";
        version = "2023-10-10";
        src = pkgs.fetchFromGitHub {
            owner = "WhoIsSethDaniel";
            repo = "lualine-lsp-progress.nvim";
            rev = "d76634e491076e45f465b31849d6ec320b436abb";
            sha256 = "sha256-Jo4I1sVZpi0hHoqW2J5JOOu96LAvyeobaD1fDZgF0Jg=";
        };
        meta.homepage = "https://github.com/WhoIsSethDaniel/lualine-lsp-progress.nvim";
    };
in {
    plugin = lualine-lsp-progress;
    type = "lua";
}
