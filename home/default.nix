{
  lib,
  config,
  inputs,
  pkgs,
  hostName,
  replaceVal,
  ...
}:
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
    ./tools
    ./wm
  ];

  virtualisation =
    let
      hasNvidia = builtins.elem "nvidia" config.boot.initrd.kernelModules;
    in
    {
      docker = {
        enable = true;
        enableOnBoot = true;
        daemon.settings.features.cdi = hasNvidia;
      };
      libvirtd.enable = gui.enable && hostName == "race4k";
      spiceUSBRedirection.enable = gui.enable && hostName == "race4k";
    };

  users = {
    defaultUserShell = pkgs."${config.shell.name}";
    groups.libvirtd.members = [ username ];
    extraGroups.vboxusers.members = [ username ];
    users."${username}" = {
      isNormalUser = user.isNormalUser;
      name = username;
      home = user.homepath;
      extraGroups = user.groups;
    };
  };

  home-manager.useGlobalPkgs = user.enableHM;
  home-manager.useUserPackages = user.enableHM;
  home-manager.users = lib.mkIf user.enableHM {
    "${username}" =
      { lib, ... }:
      {
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
            ".cargo/config.toml" = {
              executable = false;
              text = replaceVal ../.cargo/config.toml {
                mold = "${pkgs.mold}";
              };
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
