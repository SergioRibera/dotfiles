{ config, inputs, lib, ... }:
let
  inherit (config) user gui;
in
{
  imports = [
      ./nvim # TODO: import correctly nvim
  ];

  home-manager.users.${user.username} = lib.mkIf user.enableHM ({ pkgs, lib, ... }: {
    imports = [
      inputs.anyrun.homeManagerModules.default
      inputs.sss.nixosModules.home-manager
    ];

    programs = {
      anyrun = lib.mkIf
        (pkgs.stdenv.buildPlatform.isLinux && gui.enable && user.enableHM)
        (import ./anyrun { inherit pkgs inputs config; });

      bat = import ./bat { inherit pkgs config; };

      # enable and config shell selected
      "${user.shell}" = lib.mkIf
        (builtins.pathExists ./${user.shell})
        (import ./${user.shell} {
          inherit pkgs config lib;
        });

      # enable and configure others
      git = lib.mkIf config.git.enable (import ./git { inherit config; });
      # TODO: fix problems with sss
      # sss = lib.mkIf gui.enable (import ./sss.nix { inherit config; });
      wezterm = lib.mkIf gui.enable (import ./wezterm);
    };

    wayland.windowManager.hyprland = lib.mkIf
      (pkgs.stdenv.buildPlatform.isLinux && gui.enable)
      (import ./hyprland { inherit gui lib; });

    services = {
      swayosd.enable = (pkgs.stdenv.buildPlatform.isLinux && gui.enable);
    };
  });
}
