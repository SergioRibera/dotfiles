{pkgs, ...}: with pkgs.vimPlugins; {
    plugin = gruvbox-nvim;
    type = "lua";
    config = ''
vim.o.background = "dark"
vim.cmd([[colorscheme gruvbox]])
    '';
}
