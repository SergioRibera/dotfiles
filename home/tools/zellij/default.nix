{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  ctx = {
    inherit (config) shell user gui;
    inherit pkgs lib;
  };
in
{
  config = lib.mkIf config.gui.enable {
    terminal.shell = lib.mkForce [ "zellij" ];
    terminal.privShell = lib.mkForce [
      "zellij"
      "--layout"
      "private"
    ];

    home-manager.users.${config.user.username} =
      { lib, ... }:
      import ../../../tools/zellij/hm.nix { inherit pkgs lib inputs ctx; };
  };
}
