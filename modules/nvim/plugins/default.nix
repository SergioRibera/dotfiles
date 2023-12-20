{pkgs, user, ...}: {
    packages = with pkgs; [
    	# Rust
	taplo

	# Js
	nodejs
	nodePackages.typescript-language-server

	# Python
	python3
	nodePackages.pyright

	# Lua
	stylua
	lua-language-server

	# Nix
	rnix-lsp
	nil
	alejandra

	# Web
	nodePackages.tailwindcss
	nodePackages.prettier
	nodePackages."@tailwindcss/language-server"
	nodePackages.vscode-html-languageserver-bin
	nodePackages.vscode-css-languageserver-bin

	# Utils
        fd
	ripgrep

	# Others
	nodePackages.vscode-json-languageserver

        # Extras
        luajitPackages.jsregexp
    ];
    plugins = with pkgs.vimPlugins; [
        # Color
        nvim-treesitter.withAllGrammars
        rainbow-delimiters-nvim
        # completion
        neogen
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
        # status bar
        nvim-navic
        lsp-status-nvim
        # Editor
        nvim-ufo
        promise-async
        cheatsheet-nvim
        # UI
        telescope-media-files-nvim
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
        (import ./git.nix {inherit user pkgs;})
        # misc
        vim-wakatime
        presence-nvim
        # instant-nvim # no one I work with uses nvim so it makes no sense
        dial-nvim
        (import ./lsp_progress.nix {inherit pkgs;})
        # (import ./nvim_conf.nix {inherit pkgs;})
    ];
}
