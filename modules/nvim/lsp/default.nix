let
  makeServers = servers: builtins.listToAttrs (builtins.map(s: {
    name = s;
    value = { enable = true; };
  }) servers);
in
{
  enable = true;
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
      { key = "<leader>nf"; lua = true; action = "require('neogen').generate"; }
      # Show implementations
      { key = "<leader>gi"; lua = true; action = "require'telescope.builtin'.lsp_implementations"; }
      # Telescope References
      { key = "<leader>gr"; lua = true; action = "require('telescope.builtin').lsp_references"; }
      # telescope definitions
      { key = "<leader>gD"; lua = true; action = "require('telescope.builtin').lsp_definitions"; }
    ];
  };
  servers = (makeServers [
    "astro"
    "bashls"
    "biome"
    "cssls"
    "dockerls"
    "html"
    "jsonls"
    "nil_ls"
    "ruff"
    "tailwindcss"
    "taplo"
  ]) // {
    rust-analyzer = {
      enable = true;
      installCargo = false;
      installRustc = false;
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
        # cache = {
        #     warmup = false,
        # },
    };
    };
  };
  preConfig = ''
    -- Override handlers
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = {
          prefix = "●",
        },
        signs = true,
        underline = true,
        update_in_insert = true
      }
    )

    -- Setup Sign Icons
    for type, icon in pairs({
      Error = " ",
      Warn = " ",
      Hint = " ",
      Info = " "
    }) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end
  '';
}
