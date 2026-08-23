{ pkgs, lib, inputs, ctx }:
{
  programs.fish = import ./module.nix { inherit (ctx) shell; };
}
