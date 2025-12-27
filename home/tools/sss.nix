{ config, lib, ... }:
let
  inherit (config) user;
in
{
  home-manager.users.${user.username} = lib.mkIf user.enableHM (
    { ... }:
    {
      programs.sss = {
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
      };
    }
  );
}
