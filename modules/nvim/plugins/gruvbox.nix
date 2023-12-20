{pkgs, ...}: with pkgs.vimPlugins; {
    plugin = gruvbox-nvim;
    type = "lua";
    config = ''
-- colorscheme related stuff
cmd "syntax enable"
cmd "syntax on"

vim.o.background = "dark"
vim.cmd([[colorscheme gruvbox]])
    '';
}
