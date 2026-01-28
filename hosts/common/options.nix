{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config) user gui age;
  inherit (age) secrets;
  shellCmd = if (config.shell.name == "nushell") then "nu" else config.shell.name;
in
{
  options = with lib; {
    ia = {
      enable = mkEnableOption {
        description = "Enable IA server.";
        default = false;
      };
      service = mkEnableOption {
        description = "Enable IA as service.";
        default = false;
      };
    };
    wm = {
      actives = mkOption {
        type = types.listOf (
          types.enum [
            "niri"
            "jay"
            "hyprland"
            "mango"
            "sway"
          ]
        );
        default = [ "niri" ];
      };
      screens = mkOption {
        type = types.listOf (
          types.submodule {
            options = {
              name = mkOption {
                type = types.str;
                default = "eDP-1";
                description = "Screen name";
              };
              position = mkOption {
                type = (
                  types.submodule {
                    options = {
                      x = mkOption {
                        type = types.int;
                        default = 0;
                        description = "Screen X position";
                      };
                      y = mkOption {
                        type = types.int;
                        default = 0;
                        description = "Screen Y position";
                      };
                    };
                  }
                );
                default = {
                  x = 0;
                  y = 0;
                };
                description = "Screen resolution";
              };
              resolution = mkOption {
                type = (
                  types.submodule {
                    options = {
                      x = mkOption {
                        type = types.int;
                        default = 1920;
                        description = "Screen X resolution";
                      };
                      y = mkOption {
                        type = types.int;
                        default = 1080;
                        description = "Screen Y resolution";
                      };
                    };
                  }
                );
                default = {
                  x = 1920;
                  y = 1080;
                };
                description = "Screen resolution";
              };
              rotation = mkOption {
                type = types.enum [
                  "normal"
                  "left"
                  "right"
                  "inverted"
                ];
                default = "normal";
                description = "Screen rotation";
              };
              scale = mkOption {
                type = types.float;
                default = 1.0;
                description = "Screen Scale";
              };
              frequency = mkOption {
                type = types.float;
                default = 60.0;
                description = "Screen frequency";
              };
            };
          }
        );
        default = [ { name = "eDP-1"; } ];
      };
    };
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
          default = "Adwaita-Dark";
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
        default = false;
      };
      complete = mkEnableOption {
        description = "Enable all configs for nvim.";
        default = false;
      };
    };
    server-network = mkEnableOption {
      description = "Enable bluetooth.";
      default = false;
    };
    bluetooth = mkEnableOption {
      description = "Enable bluetooth.";
      default = false;
    };
    audio = mkEnableOption {
      description = "Enable audio.";
      default = true;
    };
    sshKeys = mkOption {
      description = "Enable ssh keys this host";
      type = types.bool;
      default = false;
    };
    games = mkOption {
      description = "Enable Games for this host";
      type = types.bool;
      default = false;
    };
    user = {
      enableHM = mkEnableOption "Enable home-manager this host";
      browser = mkOption {
        type = types.enum [
          "firefox"
          "chromium"
          "zen"
          "none"
        ];
        default = "none";
      };
      osVersion = mkOption {
        type = types.str;
        default = "24.11";
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
    terminal = {
      name = mkOption {
        type = types.enum [
          "foot"
          "wezterm"
          "rio"
          "alacritty"
        ];
        default = "rio";
      };
      command = mkOption {
        type = types.listOf types.str;
        default = [
          "rio"
          "-e"
        ];
      };
    };
    shell = {
      name = mkOption {
        type = types.enum [
          "fish"
          "nushell"
        ];
        default = "fish";
      };
      command = mkOption {
        type = types.listOf types.str;
        default = [ "fish" ];
      };
      privSession = mkOption {
        type = types.listOf types.str;
        default = [
          "fish"
          "-P"
        ];
      };
      aliases =
        let
          ssh-base = [
            {
              name = "rs";
              idx = 0;
            }
            {
              name = "mc";
              idx = 1;
            }
          ];
          ssh-aliases = builtins.listToAttrs (
            map (
              {
                name,
                idx,
                path ? secrets.rustlanges.path,
              }:
              {
                name = "ssh-${name}";
                value = ''ssh -i ${path} $"root@(open ${secrets.hosts.path} | lines | get ${toString idx})"'';
              }
            ) ssh-base
          );
        in
        mkOption {
          type = types.attrs;
          default = {
            cmake = "cargo make";
            neovide = "neovide --fork";
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
            nb = "nom build";
            nixdev = "nom develop -c ${shellCmd}";
            nixdevpriv = "nom develop -c ${builtins.concatStringsSep " " config.shell.privSession}";
            nixclear = "nix-store --gc";
            nixcleanup = "sudo nix-collect-garbage --delete-older-than 1d";
            nixlistgen = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";
            nixforceclean = "sudo nix-collect-garbage -d";
          }
          // ssh-aliases;
        };
    };
  };
}
