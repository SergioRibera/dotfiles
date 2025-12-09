{ pkgs, lib, config, mkTheme, ... }:
let
  inherit (config) user gui;

  theme = mkTheme gui.theme.colors;
  sosdEnabled = config.home-manager.users.${user.username}.programs.sosd.enable;
in
{
  home-manager.users.${user.username} = lib.mkIf user.enableHM ({ ... }: {
    services = {
      udiskie.enable = true;
      swayosd = lib.mkIf (pkgs.stdenv.buildPlatform.isLinux && gui.enable && !sosdEnabled) {
        enable = true;
        stylePath = pkgs.writeText "swayosd.css" (theme.swayosd);
      };
    };
  });

  services = {
    ollama = {
      enable = config.ia.enable;
      package = pkgs.ollama-vulkan;
      loadModels = lib.optionals config.ia.service ["deepseek-r1:70b"];
    };
  };
}
