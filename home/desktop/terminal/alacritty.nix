{ config, lib, ... }:
let
  inherit (config) terminal;
  shellProgram = builtins.head terminal.shell;
  shellArgs = builtins.tail terminal.shell;
in
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
      # Bare `alacritty` (no -e) launches the same thing the WM bind launches.
      terminal.shell = {
        program = shellProgram;
        args = shellArgs;
      };
      general.import = [ "dank-theme.toml" ];
    };
  };
}
