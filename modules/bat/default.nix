{ pkgs, config, ... }: {
  enable = true;
  # TODO: add aliases or config for bat-extras
  extraPackages = with pkgs.bat-extras; [ batman batpipe batdiff batgrep ];
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
