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

  myPluginsSrc = pkgs.fetchFromGitHub {
    owner = "SergioRibera";
    repo = "my-dms-plugins";
    rev = "0b5366244c85a1b7ca990e251c4fa86d83d1bc50";
    sha256 = "sha256-JqAVBY+bcJcnSpwDpKjlKA/SVMh1Vw58xnbTjqpvj1E=";
  };
  pluginFromRepo =
    name:
    pkgs.runCommandLocal "dms-plugin-${name}" { } ''
      cp -r ${myPluginsSrc}/${name} $out
    '';
in
{
  systemd.user.services.niri-flake-polkit.enable = !(gui.enable && niriEnabled);

  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "gtk3";
    QT_QPA_PLATFORMTHEME_QT6 = "gtk3";
  };

  home-manager.users.${user.username} = lib.mkIf (user.enableHM) (
    { config, lib, ... }:
    {
      imports = [
        inputs.dms.homeModules.dank-material-shell
      ]
      ++ lib.optionals niriEnabled [
        inputs.dms.homeModules.niri
      ];

      home.activation.copyDmsSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        SOURCE=${./settings.json}
        TARGET_FOLDER=${config.home.homeDirectory}/.config/DankMaterialShell
        TARGET=$TARGET_FOLDER/settings.json

        $DRY_RUN_CMD mkdir -p $TARGET_FOLDER
        if [ ! -f "$TARGET" ] || ! cmp -s "$SOURCE" "$TARGET"; then
          $DRY_RUN_CMD cp -f "$SOURCE" "$TARGET"
        fi
      '';

      programs.dank-material-shell = {
        enable = gui.enable;

        enableSystemMonitoring = false;
        enableVPN = true;
        enableDynamicTheming = true;
        enableAudioWavelength = true;
        enableCalendarEvents = true;

        niri.includes.enable = false;

        plugins = {
          DockerManager = {
            src = pkgs.fetchFromGitHub {
              owner = "LuckShiba";
              repo = "DmsDockerManager";
              rev = "v1.2.0";
              sha256 = "sha256-VoJCaygWnKpv0s0pqTOmzZnPM922qPDMHk4EPcgVnaU=";
            };
          };
          Ansync.src = pluginFromRepo "Ansync";
          BluetoothBatteryBadges.src = pluginFromRepo "BluetoothBatteryBadges";
          DankFerricast.src = pluginFromRepo "DankFerricast";
        };
      };
    }
  );
}
