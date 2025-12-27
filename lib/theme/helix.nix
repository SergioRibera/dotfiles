colors: {
  "ui.background" = {
    bg = colors.base00;
  };
  "ui.virtual.whitespace" = colors.base03;
  "ui.virtual.jump-label" = {
    fg = "blue";
    modifiers = [
      "bold"
      "underlined"
    ];
  };
  "ui.virtual.ruler" = {
    bg = colors.base01;
  };
  "ui.menu" = {
    fg = colors.base05;
    bg = colors.base01;
  };
  "ui.menu.selected" = {
    fg = colors.base01;
    bg = colors.base04;
  };
  "ui.linenr" = {
    fg = colors.base03;
    bg = colors.base01;
  };
  "ui.popup" = {
    bg = colors.base01;
  };
  "ui.window" = {
    bg = colors.base01;
  };
  "ui.linenr.selected" = {
    fg = colors.base04;
    bg = colors.base01;
    modifiers = [ "bold" ];
  };
  "ui.selection" = {
    bg = colors.base02;
  };
  "comment" = {
    fg = colors.base03;
    modifiers = [ "italic" ];
  };
  "ui.statusline" = {
    fg = colors.base04;
    bg = colors.base01;
  };
  "ui.cursor" = {
    fg = colors.base04;
    modifiers = [ "reversed" ];
  };
  "ui.cursor.primary" = {
    fg = colors.base05;
    modifiers = [ "reversed" ];
  };
  "ui.text" = colors.base05;
  "operator" = colors.base05;
  "ui.text.focus" = colors.base05;
  "variable" = colors.base08;
  "constant.numeric" = colors.base09;
  "constant" = colors.base09;
  "attribute" = colors.base09;
  "type" = colors.base0A;
  "ui.cursor.match" = {
    fg = colors.base0A;
    modifiers = [ "underlined" ];
  };
  "string" = colors.base0B;
  "variable.other.member" = colors.base0B;
  "constant.character.escape" = colors.base0C;
  "function" = colors.base0D;
  "constructor" = colors.base0D;
  "special" = colors.base0D;
  "keyword" = colors.base0E;
  "label" = colors.base0E;
  "namespace" = colors.base0E;
  "ui.help" = {
    fg = colors.base06;
    bg = colors.base01;
  };

  "markup.heading" = colors.base0D;
  "markup.list" = colors.base08;
  "markup.bold" = {
    fg = colors.base0A;
    modifiers = [ "bold" ];
  };
  "markup.italic" = {
    fg = colors.base0E;
    modifiers = [ "italic" ];
  };
  "markup.strikethrough" = {
    modifiers = [ "crossed_out" ];
  };
  "markup.link.url" = {
    fg = colors.base09;
    modifiers = [ "underlined" ];
  };
  "markup.link.text" = colors.base08;
  "markup.quote" = colors.base0C;
  "markup.raw" = colors.base0B;

  "diff.plus" = colors.base0B;
  "diff.delta" = colors.base09;
  "diff.minus" = colors.base08;

  "diagnostic" = {
    modifiers = [ "underlined" ];
  };
  "ui.gutter" = {
    bg = colors.base01;
  };
  "info" = colors.base0D;
  "hint" = colors.base03;
  "debug" = colors.base03;
  "warning" = colors.base09;
  "error" = colors.base08;

  "ui.bufferline" = {
    fg = colors.base04;
    bg = colors.base00;
  };
  "ui.bufferline.active" = {
    fg = colors.base06;
    bg = colors.base01;
  };
}
