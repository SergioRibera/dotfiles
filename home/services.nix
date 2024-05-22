{ inputs, pkgs, lib, config, ... }:
let
  inherit (config) user gui;
in
{
  home-manager.users.${user.username} = lib.mkIf user.enableHM ({ ... }: {
    services = {
      swayosd.enable = (pkgs.stdenv.buildPlatform.isLinux && gui.enable);
      wired = {
        package = inputs.wired.packages.${pkgs.system}.default;
        enable = (pkgs.stdenv.buildPlatform.isLinux && gui.enable);
      };
    };
  });
}
