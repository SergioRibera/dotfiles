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
    ] ++ lib.optionals pkgs.stdenv.buildPlatform.isDarwin [
      inputs.nixvim.nixosDarwinModules.nixvim
    ];

    home.packages = with pkgs; lib.mkIf audio [ playerctl ];

    programs = {
      carapace = lib.mkIf (shell.name == "nushell") {
        enable = true;
        enableNushellIntegration = true;
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
