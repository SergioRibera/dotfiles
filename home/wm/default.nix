{ lib, config, inputs, pkgs, ... }: let
  inherit (config) gui user;
in {
  home-manager.users.${user.username} = lib.mkIf user.enableHM {
    options = with lib; {
      shell = {
        privSession = mkOption {
          type = types.listOf types.str;
          default = config.shell.privSession;
        };
      };
    };

    imports = [
      inputs.niri.homeModules.niri
      ./niri
    ];

    config = {
      wayland.windowManager.hyprland = lib.mkIf
        (pkgs.stdenv.buildPlatform.isLinux && gui.enable)
        (import ./hyprland.nix { inherit inputs lib gui pkgs; });
    };
  };
}
