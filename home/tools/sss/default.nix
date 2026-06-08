{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config) user;
  inherit (user) username;

  themeTpl = pkgs.writeText "sss-theme.toml.tmpl" (builtins.readFile ./theme.toml.tmpl);

  matugenCfg = pkgs.writeText "sss-matugen.toml" ''
    [templates.sss]
    input_path = "${themeTpl}"
    output_path = "${user.homepath}/.config/sss/dms-colors.toml"
  '';
in
{
  home-manager.users.${username} = lib.mkIf user.enableHM (
    { ... }:
    {
      programs.sss = {
        enable = true;

        imports = [ "~/.config/sss/dms-colors.toml" ];

        code = {
          enable = true;
          line-numbers = true;
          theme = config.gui.theme.name;
        };

        cli = {
          interactive = true;
          remember-last-selection = true;
        };

        general = {
          shadow = true;
          shadow-image = true;
          notify = true;
          author = "@SergioRibera";
        };
      };

      xdg.configFile = {
        "matugen/templates/sss.toml".source = themeTpl;
        "matugen/dms/configs/sss.toml".source = matugenCfg;
      };
    }
  );
}
