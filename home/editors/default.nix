{ config, inputs, lib, pkgs, mkTheme, ... }:
let
  inherit (config) shell user gui;
in
{
  imports = [ ./zed ];

  home-manager.users.${user.username} = lib.mkIf user.enableHM ({ ... }: {
     programs = {
       neovim = {
         defaultEditor = config.nvim.enable;
         vimdiffAlias = config.nvim.enable;
       };
       nixvim = { enable = config.nvim.enable; } // (import ./nvim { cfg = config.nvim; inherit inputs pkgs lib gui user shell; });
       helix = (import ./helix { inherit pkgs gui lib mkTheme; });
     };
  });
}
