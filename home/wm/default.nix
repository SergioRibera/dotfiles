{ lib, config, inputs, pkgs, ... }: let
  inherit (config) gui user;
in {
  home-manager.users.${user.username} = lib.mkIf user.enableHM {
    imports = [ ]
    ++ lib.optionals pkgs.stdenv.buildPlatform.isDarwin [ ]
    ++ lib.optionals pkgs.stdenv.buildPlatform.isLinux [
      inputs.niri.homeModules.niri
      ./niri
    ];

    wayland.windowManager.hyprland = lib.mkIf
      (pkgs.stdenv.buildPlatform.isLinux && gui.enable)
      (import ./hyprland.nix { inherit inputs lib gui pkgs; });
  };
}
