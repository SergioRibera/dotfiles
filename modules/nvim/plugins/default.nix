{pkgs, user, ...}: let
   lsp-progress = pkgs.vimUtils.buildVimPlugin {
    pname = "lsp-progress.nvim";
    version = "2023-12-21";
    src = pkgs.fetchFromGitHub {
      owner = "linrongbin16";
      repo = "lsp-progress.nvim";
      rev = "cabf7fde50cc0dad367a03a1542d9670d1118bd0";
      sha256 = "sha256-qcKPcqHH1BEE9fnPxmpNsEt4mSnFsU3giof1bMvtJIY=";
    };
    meta.homepage = "https://github.com/linrongbin16/lsp-progress.nvim";
  };
   cmp-dotenv = pkgs.vimUtils.buildVimPlugin {
    pname = "cmp-dotenv.nvim";
    version = "2023-12-26";
    src = pkgs.fetchFromGitHub {
      owner = "SergioRibera";
      repo = "cmp-dotenv";
      rev = "e82cb22a3ee0451592e2d4a4d99e80b97bc96045";
      sha256 = "sha256-AmuFfbzQLSLkRT0xm3f0S4J+3XBpYjshKgjhhAasRLw=";
    };
    meta.homepage = "https://github.com/SergioRibera/cmp-dotenv";
  };
in {
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
	nodePackages.bash-language-server
	nodePackages.vscode-json-languageserver
        nodePackages.yaml-language-server

        # Extras
        luajitPackages.jsregexp
    ];
    plugins = with pkgs.vimPlugins; [
        # Colors
        nvim-colorizer-lua
        nvim-treesitter.withAllGrammars
        rainbow-delimiters-nvim
        # completion
        neogen
        cmp-nvim-lsp
        cmp-dotenv
        cmp-nvim-lsp-signature-help
        # Snippets
        luasnip
        cmp_luasnip
        friendly-snippets
        # LSP
        crates-nvim
        trouble-nvim   # show diagnostics
        lspkind-nvim   # icons for lsp
        # status bar
        nvim-navic
        lsp-progress
        # Editor
        nvim-ufo
        promise-async
        cheatsheet-nvim
        # UI
        nvim-web-devicons
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
