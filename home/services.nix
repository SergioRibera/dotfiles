{ inputs, pkgs, lib, config, mkTheme, ... }:
let
  inherit (config) user gui;

  theme = mkTheme gui.theme.colors;
in
{
  home-manager.users.${user.username} = lib.mkIf user.enableHM ({ ... }: {
    services = {
      udiskie.enable = true;
      wired = {
        package = inputs.wired.packages.${pkgs.system}.default;
        enable = (pkgs.stdenv.buildPlatform.isLinux && gui.enable);
      };
      swayosd = lib.mkIf (pkgs.stdenv.buildPlatform.isLinux && gui.enable) {
        enable = true;
        stylePath = pkgs.writeText "swayosd.css" (theme.swayosd);
      };
    };
  });
}
