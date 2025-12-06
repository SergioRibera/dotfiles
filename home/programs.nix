{ config, inputs, lib, pkgs, ... }:
let
  inherit (config) shell user gui audio;
in
{
  home-manager.users.${user.username} = lib.mkIf user.enableHM ({ ... }: {
    imports = [
      inputs.sss.nixosModules.home-manager
    ] ++ lib.optionals pkgs.stdenv.buildPlatform.isLinux [
      inputs.nixvim.homeModules.nixvim
      inputs.sosd.nixosModules.home-manager
    ] ++ lib.optionals pkgs.stdenv.buildPlatform.isDarwin [
      inputs.nixvim.nixosDarwinModules.nixvim
    ];

    home.packages = with pkgs; lib.mkIf audio [ playerctl ];

    programs = {
      eww = lib.mkIf (pkgs.stdenv.buildPlatform.isLinux && gui.enable) {
        enable = true;
        configDir = ./desktop/eww;
      };

      bat = import ./tools/bat.nix { inherit pkgs config; };

      carapace = lib.mkIf (shell.name == "nushell") {
        enable = true;
        enableNushellIntegration = true;
      };

      # enable and configure others
      git = lib.mkIf config.git.enable (import ./tools/git.nix { inherit config; });
      sss = lib.mkIf gui.enable (import ./tools/sss.nix { inherit config; });
      sosd = {
        enable = (pkgs.stdenv.buildPlatform.isLinux && gui.enable && user.enableHM && false);
        globals = {
          animation_duration = 1.0;
          show_duration = 5.0;
          background = "#000";
          foreground_color = "#fff";
        };
        battery = {
          enabled = true;
          refresh_time = 30.0;
          level."15" = {
            icon = "󰁺";
            show_duration = 10.0;
            background = "#ff6961";
            foreground = "#fff";
          };
          level."30" = {
            icon = "󰁼";
            show_duration = 5.0;
            background = "#000";
            foreground = "#fff";
          };
        };
        urgency = {
          low = {
            show_duration = 5.0;
            background = "#000";
            foreground_color = "#fff";
          };
          normal = {
            show_duration = 5.0;
            background = "#000";
            foreground_color = "#fff";
          };
          critical = {
            show_duration = 10.0;
            background = "#ff6961";
            foreground_color = "#fff";
          };
        };
      };

      obs-studio = {
        enable = gui.enable;
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          advanced-scene-switcher
          obs-backgroundremoval
          obs-advanced-masks
          distroav
        ];
      };
    };
  });
}
