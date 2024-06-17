{ config, inputs, lib, pkgs, ... }:
let
  inherit (config) shell user gui;
in
{
  home-manager.users.${user.username} = lib.mkIf user.enableHM ({ ... }: {
    imports = [
      inputs.anyrun.homeManagerModules.default
      inputs.sss.nixosModules.home-manager
      inputs.wired.homeManagerModules.default
    ] ++ lib.optionals pkgs.stdenv.buildPlatform.isLinux [
      inputs.nixvim.homeManagerModules.nixvim
    ] ++ lib.optionals pkgs.stdenv.buildPlatform.isDarwin [
      inputs.nixvim.nixosDarwinModules.nixvim
    ];

    programs = {
      nixvim = { enable = config.nvim.enable; } // (import ./editors/nvim { cfg = config.nvim; inherit inputs pkgs lib gui user shell; });
      anyrun = lib.mkIf
        (pkgs.stdenv.buildPlatform.isLinux && gui.enable && user.enableHM)
        (import ./desktop/anyrun.nix { inherit pkgs inputs config; });

      bat = import ./tools/bat.nix { inherit pkgs config; };

      # enable and config shell selected
      "${shell.name}" = lib.mkIf
        (builtins.pathExists ./shells/${shell.name})
        (import ./shells/${shell.name} {
          inherit pkgs config lib;
        });
      carapace = lib.mkIf (shell.name == "nushell") {
        enable = true;
        enableNushellIntegration = true;
      };

      helix = (import ./editors/helix { inherit pkgs gui lib; });
      # enable and configure others
      git = lib.mkIf config.git.enable (import ./tools/git.nix { inherit config; });
      sss = lib.mkIf gui.enable (import ./tools/sss.nix { inherit config; });
      wezterm = lib.mkIf gui.enable (import ./desktop/terminal/wezterm.nix { inherit config lib; });

      obs-studio = {
        enable = gui.enable;
        # plugins = with pkgs.obs-studio-plugins; [
        # ];
      };
    };

    wayland.windowManager.hyprland = lib.mkIf
      (pkgs.stdenv.buildPlatform.isLinux && gui.enable)
      (import ./wm/hyprland.nix { inherit inputs gui lib pkgs; });
  });
}
