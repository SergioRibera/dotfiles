{ user, pkgs, ... }: with pkgs.vimPlugins; {
    plugin = gitsigns-nvim;
    type = "lua";
    config = builtins.readFile ./git.lua;
}
