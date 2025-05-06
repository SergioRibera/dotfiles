
{ config, mkTheme, ... }: let
  theme = mkTheme config.gui.theme.colors;
in {
  home-manager.users.${config.user.username}.programs.alacritty = {
    enable = (config.gui.enable && config.terminal.name == "alacritty");
    settings = {
      font.size = 12;
      colors = theme.alacritty;
      window = {
        dynamic_padding = true;
        padding = {
          x = 5;
          y = 5;
        };
      };
      cursor = {
        style = {
          shape = "Beam";
          blinking = "On";
        };
        vi_mode_style = {
          shape = "Block";
          blinking = "On";
        };
      };
    };
  };
}
