{ inputs, config, lib, ... }:
let
  inherit (config) user gui nvim;
in
{
  # Base plugins
  home-manager.users."${user.username}" = lib.mkIf (nvim.enable) ({ pkgs, lib, ... }: {
    imports = lib.mkIf pkgs.stdenv.buildPlatform.isLinux [
      inputs.nxvim.nixosModules.nixvim
    ] ++ lib.mkIf pkgs.stdenv.buildPlatform.isDarwin [
      inputs.nxvim.nixosDarwinModules.nixvim
    ];
    # Neovide optional
    home.packages = lib.lists.otpional (nvim.neovide && gui.enable) [ pkgs.neovide ];

    programs = {
      nixvim = builtins.trace "Generating nxvim" (import ./package { cfg = nvim; inherit inputs pkgs lib gui user; });
      git = import ../git { inherit config; };
      fish = import ../fish { inherit pkgs config lib; };
      wezterm = lib.mkIf gui.enable (import ../wezterm);
    };
  });
}
