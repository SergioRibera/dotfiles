{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (config) user;
in
{
  home-manager.users.${user.username} = lib.mkIf user.enableHM (
    { ... }:
    {
      services = {
        udiskie.enable = true;
        trayscale = {
          enable = config.gui.enable && config.games;
          hideWindow = true;
        };
      };
    }
  );

  services = {
    ollama = {
      enable = config.ia.enable;
      package = pkgs.ollama-vulkan;
      loadModels = lib.optionals config.ia.service [ "deepseek-r1:70b" ];
    };
  };
}
