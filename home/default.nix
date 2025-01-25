{ lib, config, inputs, pkgs, ... }:
let
  inherit (config) user gui;
  inherit (user) username;
in
{
  imports = [
    ./services.nix
    ./packages.nix
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
    libvirtd.enable = gui.enable;
    spiceUSBRedirection.enable = true;
    # virtualbox = {
    #   guest = {
    #     enable = true;
    #     dragAndDrop = true;
    #     clipboard = true;
    #   };
    #   host = {
    #     enable = true;
    #     # enableExtensionPack = true;
    #     addNetworkInterface = true;
    #   };
    # };
  };

  users = {
    defaultUserShell = pkgs."${config.shell.name}";
    groups.libvirtd.members = [username];
    extraGroups.vboxusers.members = [username];
    users."${username}" = {
      isNormalUser = user.isNormalUser;
      name = username;
      home = user.homepath;
      extraGroups = user.groups;
    };
  };

  nixpkgs.overlays = [ inputs.fenix.overlays.default ];

  home-manager.useGlobalPkgs = user.enableHM;
  home-manager.useUserPackages = user.enableHM;
  home-manager.users = lib.mkIf user.enableHM {
    "${username}" = { lib, ... }: {
      programs.home-manager.enable = true;
      _module.args = { inherit inputs config; };

      home = {
        inherit username;
        homeDirectory = user.homepath;
        stateVersion = user.osVersion;

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
            source = ../.cargo/config.toml;
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
