{ pkgs, lib, ... }: rec {
  replaceVal = src: replacements: let
      content = builtins.readFile src;
    in
      lib.foldl (acc: name:
        lib.replaceStrings ["@${name}@"] [replacements.${name}] acc
      ) content (lib.attrNames replacements);
  mkTheme = pkgs.callPackage ./theme { inherit replaceVal; };
}
