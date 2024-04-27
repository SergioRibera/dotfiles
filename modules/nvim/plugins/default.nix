{ pkgs, user, cfg, gui }:
let
  lib = pkgs.lib;
in
{
  # completion
  cmp = import ../plugins/cmp.nix { inherit cfg; lib = pkgs.lib; };
  cmp-buffer.enable = true;
  cmp-cmdline.enable = true;
  cmp-path.enable = true;
  # status bar
  lualine = import ../plugins/lualine.nix { inherit cfg; colors = gui.theme.colors; lib = pkgs.lib; };

  # Editor
  nvim-autopairs.enable = true;
  indent-blankline = {
    enable = true;
    settings.indent.char = "▎";
    settings.indent.smart_indent_cap = true;
  };

  # UI
  telescope = import ../plugins/telescope.nix { inherit cfg; lib = pkgs.lib; };
  lspkind = {
    enable = true;
    mode = "symbol";
    symbolMap = {
      Folder = "";
      Enum = "";
    };
    cmp = {
      # ellipsisChar = "...";
      maxWidth = 50;
      after = ''
        function()
          local m = vim_item.menu and vim_item.menu or ""
          if #m > 25 then
            vim_item.menu = string.sub(m, 1, 20) .. "..."
          end
          return vim_item
        end
      '';
    };
  };
  which-key.enable = true;
} // lib.optionalAttrs cfg.complete {
  # Colors
  nvim-colorizer.enable = true;
  rainbow-delimiters.enable = true;
  treesitter.enable = true;

  # completion
  neogen = {
    enable = true;
    snippetEngine = "luasnip";
  };
  cmp-nvim-lsp.enable = true;
# cmp-dotenv
  cmp-nvim-lsp-signature-help.enable = true;

  # Snippets
  luasnip.enable = true;
  friendly-snippets.enable = true;

  # LSP
  lsp = import ../lsp;
  crates-nvim.enable = true;

  # Debug
  trouble.enable = true; # show diagnostics
  # just println! xd
  # nvim-dap
  # nvim-dap-ui
  # nvim-dap-virtual-text

  # Extras
# codeshot
  twilight.enable = true;
  gitsigns = import ../plugins/git.nix;
  presence-nvim = {
    enable = true;
    buttons = [{ label = "Cosas/Things"; url = "https://rustlang-es.org"; }];
  };
  # instant.enable = true; # no one I work with uses nvim so it makes no sense
}
