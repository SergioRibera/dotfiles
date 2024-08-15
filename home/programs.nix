{ config, inputs, lib, pkgs, ... }:
let
  inherit (config) shell user gui age;
  inherit (age) secrets;
in
{
  home-manager.users.${user.username} = lib.mkIf user.enableHM ({ ... }: {
    imports = [
      inputs.anyrun.homeManagerModules.default
      inputs.sss.nixosModules.home-manager
    ] ++ lib.optionals pkgs.stdenv.buildPlatform.isLinux [
      inputs.nixvim.homeManagerModules.nixvim
      inputs.wired.homeManagerModules.default
    ] ++ lib.optionals pkgs.stdenv.buildPlatform.isDarwin [
      inputs.nixvim.nixosDarwinModules.nixvim
    ];

    programs = {
      nixvim = { enable = config.nvim.enable; } // (import ./editors/nvim { cfg = config.nvim; inherit inputs pkgs lib gui user shell; });
      anyrun = lib.mkIf
        (pkgs.stdenv.buildPlatform.isLinux && gui.enable && user.enableHM)
        (import ./desktop/anyrun.nix { inherit pkgs inputs config; });

      bat = import ./tools/bat.nix { inherit pkgs config; };

      carapace = lib.mkIf (shell.name == "nushell") {
        enable = true;
        enableNushellIntegration = true;
      };

      helix = (import ./editors/helix { inherit pkgs gui lib; });
      # enable and configure others
      git = lib.mkIf config.git.enable (import ./tools/git.nix { inherit config; });
      sss = lib.mkIf gui.enable (import ./tools/sss.nix { inherit config; });

      obs-studio = {
        enable = gui.enable;
        # plugins = with pkgs.obs-studio-plugins; [
        # ];
      };

      ssh = {
        addKeysToAgent = "yes";
      };
    };
  });
}
