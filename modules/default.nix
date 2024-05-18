{ config, inputs, lib, pkgs, ... }:
let
  inherit (config) user gui;
in
{
  home-manager.users.${user.username} = lib.mkIf user.enableHM ({ ... }: {
    imports = [
      inputs.anyrun.homeManagerModules.default
      inputs.sss.nixosModules.home-manager
      inputs.wired.homeManagerModules.default
    ] ++ lib.optionals pkgs.stdenv.buildPlatform.isLinux [
      inputs.nixvim.homeManagerModules.nixvim
    ] ++ lib.optionals pkgs.stdenv.buildPlatform.isDarwin [
      inputs.nixvim.nixosDarwinModules.nixvim
    ];

    programs = {
      nixvim = { enable = config.nvim.enable; } // (import ./nvim/package { cfg = config.nvim; inherit inputs pkgs lib gui user; });
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
      (import ./hyprland { inherit inputs gui lib pkgs; });

    services = {
      swayosd.enable = (pkgs.stdenv.buildPlatform.isLinux && gui.enable);
      wired = {
        package = inputs.wired.packages.${pkgs.system}.default;
        enable = (pkgs.stdenv.buildPlatform.isLinux && gui.enable);
      };
    };

    xdg.configFile."wired/wired.ron".text = lib.optionalString
      (pkgs.stdenv.buildPlatform.isLinux && gui.enable)
      (import ./wired { colors = gui.theme.colors; });
  });
}
