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
  mkLazyPlugin = pkg: { lazy ? null, event ? null, cmd ? null, main ? null, dependencies ? null, opts ? null }: {
    inherit pkg opts lazy event main dependencies;
  };
  mkTreesitter = list: map (x: pkgs.vimPlugins.nvim-treesitter-parsers.${x}) list;
in
with pkgs.vimPlugins;
[
  inputs.self.packages.${pkgs.system}.nvim-surround

  nvim-web-devicons
  # completion
  which-key-nvim
  (mkLazyPlugin nvim-cmp {
    opts = import ./cmp.nix { inherit cfg; lib = pkgs.lib; };
    event = ["InsertEnter" "CmdlineEnter"];
    dependencies = with pkgs.vimPlugins; [
      cmp-buffer
      cmp-cmdline
      cmp-path
    ] ++ lib.optionals cfg.complete [
      cmp-nvim-lsp
      cmp-nvim-lsp-signature-help
      inputs.self.packages.${pkgs.system}.nvim-cmp-dotenv
    ];
  })
  # status bar
  (mkLazyPlugin lualine-nvim {
    event = ["VimEnter"];
    opts = import ./lualine.nix { inherit cfg; colors = gui.theme.colors; lib = pkgs.lib; };
  })

  # Editor
  nvim-autopairs
  (mkLazyPlugin indent-blankline-nvim-lua {
    main = "ibl";
    lazy = false;
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
  inputs.self.packages.${pkgs.system}.nvim-wakatime
  (mkLazyPlugin inputs.self.packages.${pkgs.system}.nvim-lsp-progress {
    opts.max_size = 80;
  })
  (mkLazyPlugin inputs.self.packages.${pkgs.system}.nvim-codeshot {
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

  nvim-lspconfig
  # Colors
  nvim-colorizer-lua
  nvim-treesitter
  (mkLazyPlugin rainbow-delimiters-nvim {
    main = "rainbow-delimiters.setup";
    opts.highlight = ibl-hl;
   })

  # completion
  (mkLazyPlugin neogen {
    opts.snippetEngine = "luasnip";
    dependencies = with pkgs.vimPlugins; [ luasnip ];
  })
# cmp-dotenv

  # Snippets
  luasnip
  friendly-snippets

  # LSP
  crates-nvim

  # Debug
  trouble-nvim # show diagnostics
  # dap = import ../plugins/dap.nix;

  # Extras
# codeshot
  twilight-nvim
  (mkLazyPlugin gitsigns-nvim { opts = import ./git.nix; })
  presence-nvim
  # instant.enable = true; # no one I work with uses nvim so it makes no sense
] ++ mkTreesitter [
  "c"
  "go"
  "sql"
  "vue"
  "nix"
  "vim"
  "lua"
  "cpp"
  "ini"
  "ron"
  "asm"
  "fish"
  "css"
  "tsx"
  "xml"
  "scss"
  "glsl"
  "json"
  "bash"
  "yaml"
  "rust"
  "wgsl"
  "llvm"
  "luau"
  "hlsl"
  "toml"
  "diff"
  "make"
  "http"
  "html"
  "mlir"
  "regex"
  "hjson"
  "json5"
  "astro"
  "cmake"
  "query"
  "ocaml"
  "jsonc"
  "elixir"
  "liquid"
  "python"
  "c_sharp"
  "haskell"
  "comment"
  "markdown"
  "gitignore"
  "wgsl_bevy"
  "gitcommit"
  "typescript"
  "javascript"
  "git_config"
  "ssh_config"
  "dockerfile"
]
