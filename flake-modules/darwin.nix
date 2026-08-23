{ inputs, ... }:
let
  darwinLib = import ../lib/mk-darwin.nix { inherit inputs; };
in
{
  flake.darwinConfigurations.mac = darwinLib.mkDarwin {
    system = "aarch64-darwin";
    name = "mac";
    profile = ../profiles/mac.nix;
  };
}
