{ pkgs, gui, ... }: let
  libx = import ../../../lib { inherit pkgs; };
  theme = (libx.mkTheme gui.theme.colors);
  keymapping = (import ./mapping.nix);
in {
  enable = false;
  themes.base16 = theme.helix;
  languages = (import ./languages.nix { inherit pkgs; });

  settings = {
    theme = "base16";
    editor = {
      line-number = "relative";
      color-modes = true;
      cursorline = true;
      cursor-shape = {
        insert = "bar";
        normal = "block";
        select = "block";
      };
      undercurl = true;
      true-color = true;
      soft-wrap.enable = true;
      indent-guides = {
        render = true;
        rainbow-option = "dim";
      };
      lsp = {
        display-messages = true;
        display-inlay-hints = false;
      };
      gutters = ["diff" "diagnostics" "line-numbers"];
      statusline = {
        separator = "";
        left = ["mode" "version-control"  "file-base-name" "diagnostics"];
        center = [];
        right = ["position"];
        mode = {
          normal = "NORMAL";
          insert = "INSERT";
          select = "SELECT";
        };
      };
      auto-pairs = true;
    };
  } // keymapping;
}
