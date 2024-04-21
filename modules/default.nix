{ config, inputs, lib, ... }:
let
  inherit (config) user gui;
in
{
  imports = [
    inputs.anyrun.homeManagerModules.default
  ];

  home-manager.users.${user.username} = lib.mkIf user.enableHM ({ pkgs, lib, ... }: {
    programs = {
      anyrun = lib.mkIf
        (pkgs.stdenv.buildPlatform.isLinux && gui.enable && user.enableHM)
        (import ./anyrun { inherit pkgs inputs config; });

      bat = import./bat { inherit pkgs config; };

      # enable and config shell selected
      "${user.shell}" = lib.mkIf
        (builtins.pathExists ./${user.shell})
        (import ./${user.shell} {
          inherit pkgs config lib;
        });

      # enable and configure others
      git = import ./git { inherit pkgs config lib; };
      wezterm = lib.mkIf gui.enable (import ./wezterm);
      # ../modules/nvim # TODO
    };

    wayland.windowManager.hyprland = lib.mkIf
      (pkgs.stdenv.buildPlatform.isLinux && gui.enable)
      (import ../modules/hyprland {
        inherit gui lib;
      });

    services = {
      swayosd.enable = (pkgs.stdenv.buildPlatform.isLinux && gui.enable);
    };
  });
}
