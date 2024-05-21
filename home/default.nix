{ lib, config, inputs, pkgs, ... }:
let
  inherit (config) user gui;
  inherit (user) username;
  inherit (pkgs.stdenv.buildPlatform) isLinux;

  extraCss = (import ../modules/theme.nix { inherit (gui.theme) colors;});
  darkTheme = {
    gtk-application-prefer-dark-theme = 1;
  };
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

      gtk = lib.mkIf (isLinux && gui.enable) {
        enable = true;
        gtk3.extraConfig = lib.mkIf (gui.theme.dark) darkTheme;
        gtk4.extraConfig = lib.mkIf (gui.theme.dark) darkTheme;
        gtk3.extraCss = extraCss;
        gtk4.extraCss = extraCss;
        theme = {
          name = "Orchis";
          package = pkgs.orchis-theme.overrideAttrs (oldAttrs: {
            border-radius = gui.theme.round;
            tweaks = [ "solid" "compact" ];
          });
        };
        iconTheme = {
          name = "Tela";
          package = pkgs.tela-icon-theme;
        };
      };

      home = {
        inherit username;
        homeDirectory = user.homepath;
        stateVersion = user.osVersion;
        sessionVariables.GTK_THEME = "Orchis";

        packages = import ./packages.nix { inherit inputs pkgs config lib; };

        pointerCursor = lib.mkIf (isLinux && gui.enable) {
          gtk.enable = true;
          name = gui.cursor.name;
          package = gui.cursor.package;
          size = gui.cursor.size;
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
        manpages.enable = user.enableMan;
      };
    };
  };

  programs = {
    "${user.shell}".enable = true;
    dconf.enable = (isLinux && gui.enable);
    xwayland.enable = (isLinux && gui.enable);
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
