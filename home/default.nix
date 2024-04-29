{ lib, config, inputs, ... }:
let
  inherit (config) user gui git;
  inherit (user) username;
in
{
  imports = [
    # TODO: fix import specific user from config
    # ./${config.user.username}
    ./common/time.nix
    ./common/network.nix
    ./common/xdg.nix
    ./common/virtualisation.nix
    ./common/fonts.nix
  ];
  # Load home user configs
  # ++ lib.lists.optionals (builtins.pathExists ./${username}) [ ./${username} ];
  # Load GUI configs
  # ++ guiImports;

  users.users."${username}" = {
    isNormalUser = user.isNormalUser;
    name = username;
    home = user.homepath;
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

        # packages = lib.optional (builtins.pathExists ./${username}/packages.nix) (import ./${username}/packages.nix { inherit pkgs; });
        packages = import ./${username}/packages.nix { inherit inputs pkgs config lib; };

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
    git.enable = git.enable;
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
  };
}
