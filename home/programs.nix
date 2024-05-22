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
      nixvim = { enable = config.nvim.enable; } // (import ../modules/nvim/package { cfg = config.nvim; inherit inputs pkgs lib gui user; });
      anyrun = lib.mkIf
        (pkgs.stdenv.buildPlatform.isLinux && gui.enable && user.enableHM)
        (import ./desktop/anyrun.nix { inherit pkgs inputs config; });

      bat = import ./tools/bat.nix { inherit pkgs config; };

      # enable and config shell selected
      "${user.shell}" = lib.mkIf
        (builtins.pathExists ./shells/${user.shell})
        (import ./shells/${user.shell} {
          inherit pkgs config lib;
        });

      # enable and configure others
      git = lib.mkIf config.git.enable (import ./tools/git.nix { inherit config; });
      sss = lib.mkIf gui.enable (import ./tools/sss.nix { inherit config; });
      wezterm = lib.mkIf gui.enable (import ./desktop/terminal/wezterm.nix);

      obs-studio = {
        enable = gui.enable;
        # plugins = with pkgs.obs-studio-plugins; [
        # ];
      };
    };

    wayland.windowManager.hyprland = lib.mkIf
      (pkgs.stdenv.buildPlatform.isLinux && gui.enable)
      (import ./wm/hyprland.nix { inherit inputs gui lib pkgs; });
  });
}
