{ config
, lib
, pkgs
, ...
}:
let
  inherit (config) user gui;
  shellCmd = if (config.shell.name == "nushell") then "nu" else config.shell.name;
in
{
  options = with lib; {
    gui = {
      enable = mkEnableOption {
        description = "Enable graphics.";
        default = false;
      };
      touchpad = mkEnableOption "Enable touchpad this host";
      theme = {
        description = "Define theming of configuration";
        name = mkOption {
          type = types.str;
          default = "gruvbox-dark";
          description = "Theme name";
        };
        gtk = mkOption {
          type = types.str;
          default = "Adwaita-dark";
          description = "GTK theme name";
        };
        colors = mkOption {
          type = types.attrs;
          default = (import ../../colorscheme/${gui.theme.name}).dark;
          description = "Base16 color scheme.";
        };
        dark = mkOption {
          type = types.bool;
          default = true;
          description = "Enable dark mode.";
        };
        round = mkOption {
          type = types.number;
          default = 5;
          description = "Set rounding for theme.";
        };
      };
      cursor = {
        name = mkOption {
          type = types.str;
          default = "Bibata-Modern-Ice";
          description = "Cursor theme name.";
        };
        package = mkOption {
          type = types.package;
          default = pkgs.bibata-cursors;
          description = "Cursor theme package.";
        };
        size = mkOption {
          type = types.number;
          default = 24;
          description = "Cursor size.";
        };
      };
    };
    git = {
      enable = mkEnableOption {
        description = "Enable git.";
        default = true;
      };
      name = mkOption {
        type = types.str;
        default = "Sergio Ribera";
      };
      email = mkOption {
        type = types.str;
        default = "56278796+SergioRibera@users.noreply.github.com";
      };
    };
    nvim = {
      enable = mkEnableOption {
        description = "Enable nvim.";
        default = true;
      };
      neovide = mkEnableOption {
        description = "Enable nvim.";
        default = true;
      };
      complete = mkEnableOption {
        description = "Enable all configs for nvim.";
        default = true;
      };
    };
    user = {
      enableHM = mkEnableOption "Enable home-manager this host";
      enableMan = mkEnableOption "Enable man pages this host";
      browser = mkOption {
        type = types.enum [ "firefox" "chromium" "none"];
        default = "none";
      };
      osVersion = mkOption {
        type = types.str;
        default = "24.05";
      };
      username = mkOption {
        type = types.str;
      };
      isNormalUser = mkOption {
        type = types.bool;
        default = true;
      };
      homepath = mkOption {
        type = types.str;
        default = "/home/${user.username}";
      };
      groups = mkOption {
        type = types.listOf types.str;
        default = [ ];
      };
    };
    shell = {
      name = mkOption {
        type = types.enum ["fish" "nushell"];
        default = "fish";
      };
      privSession = mkOption {
        type = types.listOf types.str;
        default = ["fish" "-P"];
      };
      aliases = mkOption {
        type = types.attrs;
        default = {
          cmake = "cargo make";
          clippy = "cargo clippy -- -D warnings";
          pedantic = "cargo clippy -- -D clippy::pedantic";
          fmtc = "cargo fmt --all --check";
          fmtf = "cargo fmt --all";
          ll = "eza -lh --icons --group-directories-first";
          la = "eza -a --icons --group-directories-first";
          lla = "eza -lah --icons";
          llag = "eza -lah --git --icons";
          ls = "eza -Gx --icons --group-directories-first";
          lsr = "eza -Tlxa --icons --group-directories-first";
          lsd = "eza -GDx --icons --color always";
          cat = "bat";
          catn = "bat --plain";
          catnp = "bat --plain --paging=never";
          gs = "git s";
          gb = "git switch";
          gbl = "git branch";
          gp = "git p";
          gbc = "git switch -c";
          glg = "git lg";
          tree = "eza --tree --icons=always";
          nixdev = "nix develop -c '${shellCmd}'";
          nixdevpriv = "nix develop -c '${builtins.concatStringsSep " " config.shell.privSession}'";
          nixclear = "nix-store --gc";
          nixcleanup = "sudo nix-collect-garbage --delete-older-than 1d";
          nixlistgen = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";
          nixforceclean = "sudo nix-collect-garbage -d";
        };
      };
    };
  };
}
