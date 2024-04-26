{ pkgs, user, cfg, gui }:
let
  lib = pkgs.lib;
  # Migrate or contribute as custom package
  # editorconfig-nvim
  # cmp-dotenv = pkgs.vimUtils.buildVimPlugin {
  #   pname = "cmp-dotenv.nvim";
  #   version = "2023-12-26";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "SergioRibera";
  #     repo = "cmp-dotenv";
  #     rev = "e82cb22a3ee0451592e2d4a4d99e80b97bc96045";
  #     sha256 = "sha256-AmuFfbzQLSLkRT0xm3f0S4J+3XBpYjshKgjhhAasRLw=";
  #   };
  #   meta.homepage = "https://github.com/SergioRibera/cmp-dotenv";
  # };
  # codeshot = pkgs.vimUtils.buildVimPlugin {
  #   pname = "codeshot.nvim";
  #   version = "2023-12-26";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "SergioRibera";
  #     repo = "codeshot.nvim";
  #     rev = "4931944474a7c3d99ba97ca5c7e81ade1a199f10";
  #     sha256 = "sha256-kvyiYsZV6BqGzkFa7moE9DAitP0uIM9yDQh378SGAjU=";
  #   };
  #   meta.homepage = "https://github.com/SergioRibera/codeshot.nvim";
  # };
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
  indent-blankline.enable = true;

  # UI
  telescope = import ../plugins/telescope.nix { inherit cfg; lib = pkgs.lib; };
  lspkind = {
    enable = true;
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
