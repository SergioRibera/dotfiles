{pkgs, config, ...}:
let
    cfg = import ./plugins {inherit pkgs;};
    user = config.laptop;
    initLua = builtins.readFile ./init.lua;
    mappingLua = builtins.readFile ./mapping.lua;
in
{
    # programs.neovim = {
    #     enable = true;
    #     defaultEditor = true;
    #     viAlias = true;
    #     vimAlias = true;
    # };
    # Base plugins
    # home.file."${user.username}".nvim = {
    # 	source = "${nvimConf}/";
    #     recursive = true;
    # };
    home-manager.users."${user.username}".programs.neovim = {
    	enable = true;
	extraLuaConfig = "${mappingLua}\n${initLua}";
	# extraPackages = cfg.packages;
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
        ];
        # ++ cfg.plugins; # Plugins by host
    };
}
