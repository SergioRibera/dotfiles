# chars get from: https://jrgraphix.net/r/Unicode/2500-257F
#                 https://en.wikipedia.org/wiki/Box-drawing_characters
#                 https://gist.github.com/dsample/79a97f38bf956f37a0f99ace9df367b9
#                 https://waylonwalker.com/drawing-ascii-boxes
#                 https://asciiflow.com
{ pkgs, cfg, gui, ... }:
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
  makeServers = servers: builtins.listToAttrs (builtins.map(s: {
    name = s;
    value = { enable = true; };
  }) servers);

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
          lsp.enabled = cfg.complete;
          omni.enabled = cfg.complete;
          path.enabled = true;
          buffer.enabled = true;
          cmdline.enabled = true;
          snippets.enabled = true;
        };
        signature.enabled = cfg.complete;
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
    auto-session = {
      enable = true;
      settings = {
        auto_create.__raw = ''function()
          local cmd = "git rev-parse --is-inside-work-tree"
          return vim.fn.system(cmd) == "true\n"
        end'';
        auto_restore_last_session.__raw = ''vim.loop.cwd() == vim.loop.os_homedir()'';
        lazy_support = true;
        bypass_save_filetypes = ["alpha" "netrw"];
        ignore_filetypes_on_save = ["checkhealth"];
        cwd_change_handling = true;
        lsp_stop_on_restore = true;

        session_lens = {
          load_on_setup = true;
          picker_opts = null;
        };

        post_cwd_changed_cmds = {
          __unkeyed."1".__raw = ''function()
            require("lualine").refresh()
          end'';
        };
      };
    };
    snacks = {
      enable = true;
      autoLoad = true;
      settings = {
        dim.enabled = true;
        input.enabled = true;
      };
    };
  }
  // lib.optionalAttrs cfg.complete ((mkPlugins [
    "wakatime"
    "neogen"
    "friendly-snippets"
    "cord" # cord.nvim
  ]) // (mkLazyPlugins [
    # Default start with LSP
    { name = "colorizer"; }
    { name = "treesitter"; }
    # { name = "dap-virtual-text"; }
  ]) // {
    rainbow-delimiters = {
      enable = true;
      highlight = ibl-hl;
    };
    # Editor
    indent-blankline = {
      enable = true;
      lazyLoad = {
        enable = true;
        settings.event = "BufReadPost";
      };
      settings = {
        indent.char = [ "▏" ];
        indent.smart_indent_cap = true;
        # indent.highlight = ibl-hl;
        scope.highlight = ibl-hl;
        # whitespace = {
        #   highlight = [ "CursorColumn" "Whitespace" ];
        #   remove_blankline_trail = false;
        # };
      };
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

    dap-ui = {
      enable = true;
      lazyLoad.settings = {
        before.__raw = ''
          function()
            require('lz.n').trigger_load('nvim-dap')
          end
        '';
        keys = [
          {
            __unkeyed-1 = "<Leader>dt";
            __unkeyed-2.__raw = ''
              function()
                require("dapui").toggle()
              end
            '';
            desc = "Toggle Debugger UI";
          }
        ];
      };
    };
    dap = let
      _cfg = name: {
          name = "Default ${name}";
          type = "codelldb";
          request = name;
          program.__raw = ''function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end
          '';
          args.__raw = ''function ()
            local argv = {}
            arg = vim.fn.input(string.format("argv: "))
            for a in string.gmatch(arg, "%S+") do
              table.insert(argv, a)
            end
            return argv
          end'';
          cwd = "\${workspaceFolder}";
          stopOnEntry = false;
          MIMode = "gdb";
          miDebuggerPath = "${pkgs.gdb}/bin/gdb";
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
          command = "${pkgs.gdb}/bin/gdb";
          args = [ "-i" "dap" ];
        };
        servers.codelldb = {
          port = "\${port}";
          executable = {
            command = "${pkgs.lldb}/bin/lldb-dap";
            args = [ "--port" "\${port}" ];
          };
        };
      };

      configurations = {
        rust = cfg;
        c = cfg;
        cpp = cfg;
      };
    };

    lsp = {
      enable = true;
      inlayHints = true;
      keymaps = {
        silent = true;
        diagnostic = {
          # Floating Diagnostic
          "<leader>e" = "open_float";
        };
        lspBuf = {
          # Codeactions
          "<leader>ga" = "code_action";
          # Hover information
          "<leader>K" = "hover";
          # Rename
          "<leader>rn" = "rename";
          # Format File
          "<C-f>" = "format";
        };
        extra = [
          # Generate documentation
          { key = "<leader>nf"; action = "<cmd>Neogen<CR>"; }
          # Show implementations
          { key = "<leader>gi"; action = "<cmd>Telescope lsp_implementations<CR>"; }
          # Telescope References
          { key = "<leader>gr"; action = "<cmd>Telescope lsp_references<CR>"; }
          # telescope symbols
          { key = "<leader>gs"; action = "<cmd>Telescope lsp_workspace_symbols<CR>"; }
          # telescope definitions
          { key = "<leader>gd"; action = "<cmd>Telescope lsp_definitions<CR>"; }
        ];
      };

      servers = (makeServers [
        "astro"
        "bashls"
        "cssls"
        "dockerls"
        "html"
        "jsonls"
        "nixd"
        "nushell"
        "slint_lsp"
        "tailwindcss"
        "taplo"
        "ts_ls"
        "volar"
      ]) // {
        rust_analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
          installRustfmt = false;
          settings = {
            cachePriming.enable = false;
            check.features = "all";
            cargo = {
              features = "all";
              allTargets = false;
              buildScripts.enable = true;
            };
            completion.snippets.custom = {
              # TODO: implement custon snippets for Rust
              # https://nix-community.github.io/nixvim/plugins/lsp/servers/rust-analyzer/settings/completion/snippets.html
            };
            diagnostics.experimental.enable = true;
            imports = {
              prefix = "self";
              granularity.group = "module";
            };
            inlayHints.enabled = false;
            # cache = {
            #     warmup = false,
            # },
          };
        };
      };
    };
  })
