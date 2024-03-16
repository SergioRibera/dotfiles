{pkgs, config, ...}:
let
    user = config.laptop;
    cfg = import ./plugins {inherit pkgs user;};
    nvimLsp = import ./lsp {inherit pkgs;};
    initLua = builtins.readFile ./init.lua;
    autocmdLua = builtins.readFile ./autocmd.lua;
    mappingLua = builtins.readFile ./mapping.lua;
    utilsLua = builtins.readFile ./utils.lua;
    tablineLua = builtins.readFile ./tabline.lua;
    extraPackages = if user.cfgType == "minimal"
                    then [ pkgs.ripgrep pkgs.fd ]
                    else cfg.packages;
    extraPlugins = if user.cfgType == "minimal"
                    then []
                    else cfg.plugins ++ [nvimLsp];
    modPlugins = if user.cfgType == "minimal"
                    then ""
                    else builtins.readFile ./plugins/mod.lua;
    miscLua = if user.cfgType == "minimal"
                    then ""
                    else builtins.readFile ./misc.lua;
in
{
    # Base plugins
    home-manager.users."${user.username}".programs.neovim = {
    	enable = true;
        inherit extraPackages;
        extraLuaConfig = autocmdLua + utilsLua + miscLua + modPlugins + initLua + mappingLua + tablineLua;
        plugins = with pkgs.vimPlugins; [
            # colorscheme
            nvim-base16
            # completion
            cmp-path
            cmp-buffer
            cmp-cmdline
            (import ./plugins/cmp.nix {inherit user pkgs;})
            # status bar
            (import ./plugins/lualine.nix {inherit user pkgs;})
            # Editor
            nvim-autopairs
            nvim-surround
            indent-blankline-nvim
            # UI
            telescope-file-browser-nvim
            telescope-ui-select-nvim
            popup-nvim
            (import ./plugins/telescope.nix {inherit user pkgs;})
        ] ++ extraPlugins; # Plugins by host
    };
}
