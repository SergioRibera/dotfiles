{ inputs, pkgs, lib, config, ... }:
let
  inherit (config) user gui;

  libx = import ../lib { inherit pkgs; };
  theme = libx.mkTheme gui.theme.colors;
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
