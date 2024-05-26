{ config, ... }: {
  enable = true;
  code = {
    enable = true;
    line-numbers = true;
    theme = config.gui.theme.name;
  };

  general = {
    shadow = true;
    shadow-image = true;
    notify = true;
    author = "@SergioRibera";
    colors = {
      background = "#FFFFFF";
      author = "#000000";
    };
  };
}
