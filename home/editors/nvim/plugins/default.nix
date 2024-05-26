# chars get from: https://jrgraphix.net/r/Unicode/2500-257F
#                 https://en.wikipedia.org/wiki/Box-drawing_characters
#                 https://gist.github.com/dsample/79a97f38bf956f37a0f99ace9df367b9
#                 https://waylonwalker.com/drawing-ascii-boxes
#                 https://asciiflow.com
{ pkgs, user, cfg, gui }:
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
    settings.indent.char = "▏";
    settings.indent.smart_indent_cap = true;
    # settings.scope.char = [ "╭" "─" ];
    # settings.indent.highlight = ibl-hl;
    # settings.scope.highlight = ibl-hl;
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
  rainbow-delimiters = {
    enable = true;
    highlight = ibl-hl;
  };
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
  dap = import ../plugins/dap.nix;

  # Extras
# codeshot
  twilight.enable = true;
  gitsigns = import ../plugins/git.nix;
  presence-nvim = {
    enable = true;
    # buttons = [{ label = "Cosas/Things"; url = "https://rustlang-es.org"; }];
  };
  # instant.enable = true; # no one I work with uses nvim so it makes no sense
}
