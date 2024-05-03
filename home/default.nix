{ lib, config, inputs, pkgs, ... }:
let
  inherit (config) user gui;
  inherit (user) username;
in
{
  imports = [
    ./hardware.nix
    ./services.nix
    ./environment.nix
    ./common/time.nix
    ./common/network.nix
    ./common/xdg.nix
    ./common/virtualisation.nix
    ./common/fonts.nix
  ];

  sound.enable = gui.enable;

  users.defaultUserShell = pkgs."${user.shell}";
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
      home = {
        inherit username;
        homeDirectory = user.homepath;
        stateVersion = user.osVersion;

        packages = import ./packages.nix { inherit inputs pkgs config lib; };

        pointerCursor = lib.mkIf (pkgs.stdenv.buildPlatform.isLinux && gui.enable) {
          gtk.enable = true;
          name = "Bibata-Modern-Ice";
          package = pkgs.bibata-cursors;
          size = 18;
        };

        file = {
          ".local/bin/wallpaper" = lib.mkIf gui.enable {
            executable = true;
            source = ../scripts/wallpaper;
          };
          ".local/bin/hyprshot" = lib.mkIf gui.enable {
            executable = true;
            source = ../scripts/hyprshot;
          };
          ".cargo/config" = {
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
        manpages.enable = user.enableMan;
      };
    };
  };

  programs = {
    "${user.shell}".enable = true;
    nh = lib.mkIf user.enableHM {
      enable = true;
      flake = "/etc/nixos";
    };
    ssh = {
      startAgent = true;
      extraConfig = ''
        AddKeysToAgent yes

        Host github.com
            IdentityFile ~/.ssh/github

        Host gitlab.com
            IdentityFile ~/.ssh/gitlab
      '';
    };
    adb.enable = config.nvim.complete;
    thunar = {
      enable = gui.enable;
      plugins = [ ];
    };

    # firefox = lib.mkIf (gui.enable && user.browser == "firefox") (import ./browser/firefox.nix { inherit lib pkgs config; });
    chromium = lib.mkIf (gui.enable && user.browser == "chromium") (import ../modules/browser/chromium.nix { inherit config; });
  };
}
