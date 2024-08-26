{ lib, config, inputs, pkgs, ... }:
let
  inherit (config) user gui;
  inherit (user) username;
in
{
  imports = [
    ./services.nix
    ./programs.nix
    ./theme.nix
    ./common/xdg.nix
    ./common/fonts.nix
    ./desktop
    ./editors
    ./shells
    ./wm
  ];

  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
    };
  };

  users.defaultUserShell = pkgs."${config.shell.name}";
  users.users."${username}" = {
    isNormalUser = user.isNormalUser;
    name = username;
    home = user.homepath;
    extraGroups = user.groups;
  };

  nixpkgs.overlays = [ inputs.fenix.overlays.default ];

  home-manager.useGlobalPkgs = user.enableHM;
  home-manager.useUserPackages = user.enableHM;
  home-manager.users = lib.mkIf user.enableHM {
    "${username}" = { lib, pkgs, ... }: {
      programs.home-manager.enable = true;
      _module.args = { inherit inputs config; };

      home = {
        inherit username;
        homeDirectory = user.homepath;
        stateVersion = user.osVersion;

        packages = import ./packages.nix { inherit inputs pkgs config lib; };

        file = {
          ".local/bin/wallpaper" = lib.mkIf gui.enable {
            executable = true;
            source = ../scripts/wallpaper;
          };
          ".local/bin/hyprshot" = lib.mkIf gui.enable {
            executable = true;
            source = ../scripts/hyprshot;
          };
          ".cargo/config.toml" = {
            executable = false;
            source = ../.cargo/config;
          };
          ".cargo/cargo-generate.toml" = {
            executable = false;
            source = ../.cargo/cargo-generate.toml;
          };
        };
      };

      manual = {
        html.enable = false;
        json.enable = false;
        manpages.enable = false;
      };
    };
  };
}
