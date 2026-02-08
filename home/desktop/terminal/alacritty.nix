{ config, ... }:
{
  home-manager.users.${config.user.username}.programs.alacritty = {
    enable = (config.gui.enable && config.terminal.name == "alacritty");
    settings = {
      font.size = 12;
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
      general.import = [ "dank-theme.toml" ];
    };
  };
}
