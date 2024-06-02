# chars get from: https://jrgraphix.net/r/Unicode/2500-257F
#                 https://en.wikipedia.org/wiki/Box-drawing_characters
#                 https://gist.github.com/dsample/79a97f38bf956f37a0f99ace9df367b9
#                 https://waylonwalker.com/drawing-ascii-boxes
#                 https://asciiflow.com
{ inputs, pkgs, user, cfg, gui }:
let
  lib = pkgs.lib;
  ibl-hl = [
    "RainbowRed"
    "RainbowYellow"
    "RainbowBlue"
    "RainbowOrange"
    "RainbowGreen"
    "RainbowViolet"
    "RainbowCyan"
  ];
  mkLazyPlugin = pkg: {
    ft ? null, init ? null,
    lazy ? null, event ? null,
    cmd ? null, main ? null,
    dependencies ? null, opts ? {}
  }: {
    inherit pkg ft opts lazy event main dependencies;
  };
  mkTreesitter = lang: ft: {
    pkg = pkgs.vimPlugins.nvim-treesitter-parsers.${lang};
    inherit ft;
  };
in
with pkgs.vimPlugins;
with inputs.self.packages.${pkgs.system};
[
  (mkLazyPlugin nvim-surround { event = "BufReadPost"; })

  nvim-web-devicons
  # completion
  which-key-nvim
  (mkLazyPlugin nvim-cmp {
    opts = import ./cmp.nix { inherit cfg; lib = pkgs.lib; };
    event = ["InsertEnter" "CmdlineEnter"];
    dependencies = with pkgs.vimPlugins; [
      cmp-path
      (mkLazyPlugin cmp-buffer { event = ["InsertEnter"]; })
      (mkLazyPlugin cmp-cmdline { event = ["CmdlineEnter"]; })
    ] ++ lib.optionals cfg.complete [
      (mkLazyPlugin cmp-nvim-lsp { event = ["BufEnter *.*"]; })
      (mkLazyPlugin cmp-nvim-lsp-signature-help { event = ["BufEnter *.*"]; })
      (mkLazyPlugin nvim-cmp-dotenv { event = ["BufEnter *.*"]; })
      (mkLazyPlugin neogen {
        event = ["BufEnter *.*"];
        opts.snippetEngine = "luasnip";
        dependencies = [ luasnip friendly-snippets ];
      })
    ];
  })
  # status bar
  (mkLazyPlugin lualine-nvim {
    event = ["VimEnter"];
    opts = import ./lualine.nix { inherit cfg; colors = gui.theme.colors; lib = pkgs.lib; };
  })

  # Editor
  (mkLazyPlugin nvim-autopairs { event = ["InsertEnter"]; })
  (mkLazyPlugin indent-blankline-nvim-lua {
    main = "ibl";
    event = "BufReadPost";
    opts = {
      indent.char = "▏";
      indent.smart_indent_cap = true;
      # scope.char = [ "╭" "─" ];
      # indent.highlight = ibl-hl;
      # scope.highlight = ibl-hl;
    };
  })

  # UI
  (mkLazyPlugin telescope-nvim {
    cmd = ["Telescope"];
    opts = import ../plugins/telescope.nix { inherit cfg; lib = pkgs.lib; };
    dependencies = [
      plenary-nvim
    ];
  })
] ++ lib.optionals cfg.complete [
  nvim-wakatime
  (mkLazyPlugin nvim-lsp-progress {
    event = ["VimEnter" "LspAttach"];
    opts.max_size = 80;
  })
  (mkLazyPlugin nvim-codeshot {
    cmd = ["SSSelected" "SSFocused"];
    opts = {
      copy = "%c | wl-copy";
      fonts = "";
      shadow_image = true;
      use_current_theme = true;
      background = "#AAAAFF";
      author = "@SergioRibera";
      author_color = "#000";
    };
  })

  (mkLazyPlugin nvim-lspconfig { event = "LspAttach"; })
  # Colors
  nvim-colorizer-lua
  (mkLazyPlugin nvim-treesitter { event = "BufReadPost"; })
  (mkLazyPlugin rainbow-delimiters-nvim {
    event = "BufReadPost";
    main = "rainbow-delimiters.setup";
    opts.highlight = ibl-hl;
   })

  # completion

  # LSP
  (mkLazyPlugin crates-nvim { ft = ["toml"]; })

  # Debug
  (mkLazyPlugin trouble-nvim { cmd = "Trouble"; }) # show diagnostics
  # dap = import ../plugins/dap.nix;

  # Extras
  (mkLazyPlugin twilight-nvim { cmd = "Twilight"; })
  (mkLazyPlugin gitsigns-nvim { event = "BufReadPost"; opts = import ./git.nix; })
  (mkLazyPlugin presence-nvim { lazy = false; })
  # instant.enable = true; # no one I work with uses nvim so it makes no sense
] ++ [
  (mkTreesitter "c" ["c" "cuda"])
  (mkTreesitter "go" ["go" "gomod" "gowork" "gotmpl"])
  (mkTreesitter "sql" ["sql"])
  (mkTreesitter "vue" ["vue"])
  (mkTreesitter "nix" ["nix"])
  (mkTreesitter "lua" ["lua"])
  (mkTreesitter "cpp" ["cpp"])
  (mkTreesitter "ini" ["ini"])
  (mkTreesitter "ron" ["ron"])
  (mkTreesitter "fish" ["fish"])
  (mkTreesitter "css" ["css" "less"])
  (mkTreesitter "tsx" ["javascript.jsx" "typescript" "typescriptreact" "typescript.tsx"])
  (mkTreesitter "xml" ["xml"])
  (mkTreesitter "scss" ["scss"])
  (mkTreesitter "glsl" ["glsl" "vert" "tesc" "tese" "frag" "geom" "comp"])
  (mkTreesitter "json" ["json"])
  (mkTreesitter "bash" ["sh" "bash"])
  (mkTreesitter "yaml" ["yaml" "yml"])
  (mkTreesitter "rust" ["rs"])
  (mkTreesitter "wgsl" ["wgsl"])
  (mkTreesitter "llvm" ["llvm"])
  (mkTreesitter "luau" ["luau"])
  (mkTreesitter "hlsl" ["hlsl"])
  (mkTreesitter "toml" ["toml"])
  (mkTreesitter "diff" ["diff"])
  (mkTreesitter "make" ["cmake" "make" "mak" "makefile"])
  (mkTreesitter "http" ["http"])
  (mkTreesitter "html" ["html" "templ"])
  (mkTreesitter "mlir" ["mlir"])
  (mkTreesitter "regex" ["regex"])
  (mkTreesitter "astro" ["astro"])
  (mkTreesitter "cmake" ["cmake"])
  (mkTreesitter "query" ["query"])
  (mkTreesitter "ocaml" ["ocaml" "menhir" "ocamlinterface" "ocamllex" "reason" "dune"])
  (mkTreesitter "jsonc" ["jsonc"])
  (mkTreesitter "liquid" ["liquid"])
  (mkTreesitter "python" ["python"])
  (mkTreesitter "c_sharp" ["cs"])
  (mkTreesitter "haskell" ["haskell" "lhaskell"])
  (mkTreesitter "comment" ["*"])
  (mkTreesitter "markdown" ["markdown"])
  (mkTreesitter "gitignore" ["gitignore"])
  (mkTreesitter "wgsl_bevy" ["wgsl_bevy"])
  (mkTreesitter "gitcommit" ["gitcommit"])
  (mkTreesitter "javascript" ["javascript" "javascriptreact"])
  (mkTreesitter "git_config" ["gitconfig"])
  (mkTreesitter "ssh_config" ["sshconfig"])
  (mkTreesitter "dockerfile" ["dockerfile"])
]
