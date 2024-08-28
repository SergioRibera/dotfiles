{ config, ... }: {
  enable = true;
  config = {
    map-syntax = [
      "*.jenkinsfile:Groovy"
      "*.props:Java Properties"
    ];
    pager = "less -FR";
    theme = config.gui.theme.colors.batTheme;
    style = "header-filename,header-filesize,rule,numbers,snip,changes,header";
  };
}
