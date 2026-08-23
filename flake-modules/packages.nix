{ ... }:
{
  perSystem = { pkgs, lib, ... }: {
    packages = lib.filterAttrs (_: lib.isDerivation) ((import ../pkgs) pkgs pkgs);
  };
}
