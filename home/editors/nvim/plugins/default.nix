# chars get from: https://jrgraphix.net/r/Unicode/2500-257F
#                 https://en.wikipedia.org/wiki/Box-drawing_characters
#                 https://gist.github.com/dsample/79a97f38bf956f37a0f99ace9df367b9
#                 https://waylonwalker.com/drawing-ascii-boxes
#                 https://asciiflow.com
{ inputs, pkgs, user, cfg, gui }:
let
  lib = pkgs.lib;
  colors = gui.theme.colors;
  ibl-hl = [
    "RainbowRed"
    "RainbowYellow"
    "RainbowBlue"
    "RainbowOrange"
    "RainbowGreen"
    "RainbowViolet"
    "RainbowCyan"
  ];
  mkPlugins = plugins: builtins.listToAttrs (builtins.map(s: {
    name = s;
    value = { enable = true; };
  }) plugins);
  mkLazyPlugin = pkg: {
    config ? true, optional ? false,
    ft ? null, init ? null,
    lazy ? true, event ? null,
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

(mkPlugins [
  "web-devicons"
  "mini-surround"
  "which-key"
]) // {
  # Completion
  blink-cmp = {
    enable = true;
    settings = {
      kind_icons = {
        Text = "󰉿";
        Method = "󰆧";
        Function = "󰊕";
        Constructor = "";
        Field = "󰜢";
        Variable = "󰀫";
        Class = "󰠱";
        Interface = "";
        Module = "";
        Property = "󰜢";
        Unit = "󰑭";
        Value = "󰎠";
        Enum = "";
        Keyword = "󰌋";
        Snippet = "";
        Color = "󰏘";
        File = "󰈙";
        Reference = "󰈇";
        Folder = "󰉋";
        EnumMember = "";
        Constant = "󰏿";
        Struct = "󰙅";
        Event = "";
        Operator = "󰆕";
        TypeParameter = "";
      };
    };
  };
  # Editor
  indent-blankline = {
    enable = true;
    settings = {
      indent.char = "▏";
      indent.smart_indent_cap = true;
      # scope.char = [ "╭" "─" ];
      # indent.highlight = ibl-hl;
      # scope.highlight = ibl-hl;
    };
  };
  lualine = {
    enable = true;
    settings = import ./lualine.nix { inherit cfg lib colors; };
  };
  telescope = { enable = true; } // (import ./telescope.nix { inherit cfg lib; });
}
// lib.optionalAttrs cfg.complete ((mkPlugins [
  "wakatime"
  "neogen"
  "luasnip"
  "lspconfig"
  "colorizer"
  "presence-nvim"
]) // {
  gitsigns = {
    enable = true;
    settings =  {
      signs = {
        add.text = "┃";
        change.text = "┃";
        delete.text = "▁";
        topdelete.text = "▔";
        changedelete.text = "┃";
        untracked.text = "┆";
      };
      numhl = true;
      attach_to_untracked = false;
      current_line_blame = true;
      update_debounce = 200;
      diff_opts.algorithm = "minimal";
    };
  };

  treesitter = {
    enable = true;
    grammarPackages = [
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
      (mkTreesitter "rust" ["rust"])
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
      (mkTreesitter "markdown" ["markdown"])
      (mkTreesitter "gitignore" ["gitignore"])
      (mkTreesitter "wgsl_bevy" ["wgsl_bevy"])
      (mkTreesitter "gitcommit" ["gitcommit"])
      (mkTreesitter "javascript" ["javascript" "javascriptreact"])
      (mkTreesitter "git_config" ["gitconfig"])
      (mkTreesitter "ssh_config" ["sshconfig"])
      (mkTreesitter "dockerfile" ["dockerfile"])
    ];
  };
})

[
  # completion
  # (mkLazyPlugin nvim-cmp {
  #   event = ["CmdlineEnter" "InsertEnter"];
  #   opts.__raw = import ./cmp.nix { inherit cfg; lib = pkgs.lib; };
  # })
  # (mkLazyPlugin cmp-cmdline { event = ["CmdlineEnter"]; })
  # (mkLazyPlugin cmp-buffer { event = ["InsertEnter"]; })
  # (mkLazyPlugin cmp-path { event = ["InsertEnter" "CmdlineEnter"]; })
] ++ lib.optionals cfg.complete [
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

  # (mkLazyPlugin cmp-nvim-lsp { event = "LspAttach"; })
  # (mkLazyPlugin cmp-nvim-lsp-signature-help { event = "LspAttach"; })
  # (mkLazyPlugin nvim-cmp-dotenv { event = ["BufEnter *.*"]; })

  # Colors
  ({ pkg = pkgs.vimPlugins.nvim-treesitter-parsers.comment; event = "BufReadPost"; })
  (mkLazyPlugin rainbow-delimiters-nvim {
    event = "BufReadPost";
    main = "rainbow-delimiters.setup";
    opts.highlight = ibl-hl;
  })

  # dap = import ../plugins/dap.nix;
]
