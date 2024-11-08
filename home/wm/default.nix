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
        command = mkOption {
          type = types.listOf types.str;
          default = config.shell.command;
        };
      };
      terminal = {
        name = mkOption {
          type = types.enum ["foot" "wezterm" "rio" "alacritty"];
          default = config.terminal.name;
        };
        command = mkOption {
          type = types.listOf types.str;
          default = config.terminal.command;
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
