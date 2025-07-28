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

  mkLazyPlugins = plugins: builtins.listToAttrs (builtins.map(s: {
    name = s.name;
    value = {
      enable = true;
      lazyLoad = {
        enable = true;
        settings = if (builtins.hasAttr "settings" s) then s.settings else { event = "LspAttach"; };
      };
    };
  }) plugins);
in
  (mkPlugins [
    "web-devicons"
    "which-key"
  ]) // (mkLazyPlugins [
    { name = "mini-surround"; settings.event = "BufReadPost"; }
  ]) // {
    lz-n = {
      enable = true;
      autoLoad = true;
    };
    # Completion
    blink-cmp = {
      enable = true;
      settings = {
        keymap = {
          "<C-space>" = [ "show" "show_documentation" "hide_documentation" ];
          "<CR>" = [ "select_and_accept" "fallback" ];
          "<Down>" = [ "select_next" "fallback" ];
          "<S-Tab>" = [ "snippet_backward" "select_prev" "fallback" ];
          "<Tab>" = [ "snippet_forward" "select_next" "fallback" ];
          "<Up>" = [ "select_prev" "fallback" ];
        };
        sources.providers = {
          lsp.enable = cfg.complete;
          path.enable = true;
          omni.enable = cfg.complete;
  				# snippets.enable = cfg.complete;
  				buffer.enable = true;
        };
        signature.enable = cfg.complete;
        completion.menu.draw.columns = [
          [ "kind_icon" ]
          { "__unkeyed.1" = "label"; gap = 2; }
          [ "label_description" ]
        ];
        appearance = {
          use_nvim_cmp_as_default = true;
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
    };
    # Editor
    indent-blankline = {
      enable = true;
      lazyLoad = {
        enable = true;
        settings.event = "BufReadPost";
      };
      settings = {
        indent.char = "▏";
        indent.smart_indent_cap = true;
        # indent.highlight = ibl-hl;
        scope.highlight = ibl-hl;
        # whitespace = {
        #   highlight = [ "CursorColumn" "Whitespace" ];
        #   remove_blankline_trail = false;
        # };
      };
    };
    lualine = {
      enable = true;
      settings = import ./lualine.nix { inherit cfg lib colors; };
    };
    telescope = {
      enable = true;
      lazyLoad = {
        enable = true;
        settings.event = "BufReadPost";
      };
    } // (import ./telescope.nix { });
  }
  // lib.optionalAttrs cfg.complete ((mkPlugins [
    "wakatime"
    "neogen"
    "friendly-snippets"
    "cord" # cord.nvim
  ]) // (mkLazyPlugins [
    # Default start with LSP
    { name = "lspconfig"; }
    { name = "colorizer"; }
    { name = "treesitter"; }
    { name = "dap-ui"; }
    { name = "dap-virtual-text"; }
  ]) // {
    rainbow-delimiters = {
      enable = true;
      highlight = ibl-hl;
    };
    gitsigns = {
      enable = true;
      lazyLoad = {
        enable = true;
        settings.event = "BufReadPost";
      };
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

    dap = let
      _cfg = name: {
          name = "Default ${name}";
          type = "gdb";
          request = name;
        };
      cfg = [(_cfg "launch")];
    in {
      enable = true;
      lazyLoad = {
        enable = true;
        settings.event = "LspAttach";
      };
      signs.dapBreakpoint = {
        text = "●";
        texthl = "Debug";
      };
      adapters = {
        # C, C++, Rust
        executables.gdb = {
          command = "gdb";
          args = [ "-i" "dap" ];
        };
      };

      configurations = {
        rust = cfg;
        c = cfg;
        cpp = cfg;
      };
    };
  })
