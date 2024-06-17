{ pkgs, gui, ... }: let
  libx = import ../../../lib { inherit pkgs; };
  theme = (libx.mkTheme gui.theme.colors);
in {
  enable = false;
  themes.base16 = theme.helix;
  languages = (import ./languages.nix { inherit pkgs; });

  settings = {
    theme = "base16";
    editor = {
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
      gutters = ["diagnostics" "line-numbers" "spacer" "diff"];
      statusline = {
        left = ["mode" "version-control" "diagnostics" "file-base-name"];
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

    keys.insert = {
      C-h = "move_char_left";
      C-j = "move_line_down";
      C-k = "move_line_up";
      C-l = "move_char_right";
      C-e = "goto_line_end";
      C-b = "goto_line_start";
    };

    keys.normal = {
      C-h = ["jump_view_left"];
      C-j = ["jump_view_down"];
      C-k = ["jump_view_up"];
      C-l = ["jump_view_right"];

      C-f = [":format"];

      tab = ["goto_next_buffer"];
      S-tab = ["goto_previous_buffer"];

      space = {
        x = ":buffer-close";
      };
    };
  };
}
