{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config) gui user wm;
  niriEnabled = (builtins.elem "niri" wm.actives);
in
{
  systemd.user.services.niri-flake-polkit.enable = !(gui.enable && niriEnabled);

  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "gtk3";
    QT_QPA_PLATFORMTHEME_QT6 = "gtk3";
  };

  home-manager.users.${user.username} = lib.mkIf (user.enableHM) (
    { ... }:
    {
      imports = [
        inputs.dms.homeModules.dank-material-shell
      ]
      ++ lib.optionals niriEnabled [
        inputs.dms.homeModules.niri
      ];

      programs.dank-material-shell = {
        enable = gui.enable;

        enableSystemMonitoring = false;
        enableVPN = true;
        enableDynamicTheming = true;
        enableAudioWavelength = true;
        enableCalendarEvents = true;

        niri.includes.enable = false;

        settings = {
          theme = "dark";
          dynamicTheming = true;
        };
        plugins = {
          DockerManager = {
            src = pkgs.fetchFromGitHub {
              owner = "LuckShiba";
              repo = "DmsDockerManager";
              rev = "v1.2.0";
              sha256 = "sha256-VoJCaygWnKpv0s0pqTOmzZnPM922qPDMHk4EPcgVnaU=";
            };
          };
        };
      };
    }
  );
}
