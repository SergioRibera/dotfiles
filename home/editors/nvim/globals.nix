{ colors, username, complete, lib }: {
  loaded_custom_tabline = 1;
  mapleader = " ";
  instant_username = username;
  autoread = true;

  neovide_cursor_antialiasing = complete; # Neovide cursor Antialiasing
  neovide_cursor_vfx_mode = lib.optional complete "pixiedust";
  # Nvim Terminal
  terminal_color_0 = colors.base00;
  terminal_color_1 = colors.base08;
  terminal_color_2 = colors.base0B;
  terminal_color_3 = colors.base0A;
  terminal_color_4 = colors.base0D;
  terminal_color_5 = colors.base0E;
  terminal_color_6 = colors.base0C;
  terminal_color_7 = colors.base05;
  terminal_color_8 = colors.base03;
  terminal_color_9 = colors.base08;
  terminal_color_10 = colors.base0B;
  terminal_color_11 = colors.base0A;
  terminal_color_12 = colors.base0D;
  terminal_color_13 = colors.base0E;
  terminal_color_14 = colors.base0C;
  terminal_color_15 = colors.base07;
  base16_gui00 = colors.base00;
  base16_gui01 = colors.base01;
  base16_gui02 = colors.base02;
  base16_gui03 = colors.base03;
  base16_gui04 = colors.base04;
  base16_gui05 = colors.base05;
  base16_gui06 = colors.base06;
  base16_gui07 = colors.base07;
  base16_gui08 = colors.base08;
  base16_gui09 = colors.base09;
  base16_gui0A = colors.base0A;
  base16_gui0B = colors.base0B;
  base16_gui0C = colors.base0C;
  base16_gui0D = colors.base0D;
  base16_gui0E = colors.base0E;
  base16_gui0F = colors.base0F;
}
