{pkgs, config, ...}:
let
    cfg = import ./plugins {inherit pkgs user;};
    user = config.laptop;
    initLua = builtins.readFile ./init.lua;
    autocmdLua = builtins.readFile ./autocmd.lua;
    mappingLua = builtins.readFile ./mapping.lua;
    utilsLua = builtins.readFile ./utils.lua;
    extraPackages = if user.cfgType == "minimal"
                    then [ pkgs.ripgrep pkgs.fd ]
                    else cfg.packages;
    extraPlugins = if user.cfgType == "minimal"
                    then []
                    else cfg.plugins;
    modPlugins = if user.cfgType == "minimal"
                    then ""
                    else builtins.readFile ./plugins/mod.lua;
in
{
    # Base plugins
    home-manager.users."${user.username}".programs.neovim = {
    	enable = true;
        inherit extraPackages;
	extraLuaConfig = autocmdLua + utilsLua + mappingLua + modPlugins + initLua;
        plugins = with pkgs.vimPlugins; [
            # Color
            # nvim-base16
            # nvim-colorizer-lua
	    (import ./plugins/gruvbox.nix {inherit pkgs;})
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
            # UI
            telescope-file-browser-nvim
            telescope-ui-select-nvim
            popup-nvim
	    (import ./plugins/telescope.nix {inherit user pkgs;})
        ] ++ extraPlugins; # Plugins by host
    };
}
