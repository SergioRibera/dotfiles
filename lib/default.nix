{ pkgs, lib, ... }:
rec {
  replaceVal =
    src: replacements:
    let
      content = builtins.readFile src;
    in
    lib.foldl (
      acc: name:
      let
        replVal =
          if (builtins.typeOf replacements.${name}) == "string" then
            replacements.${name}
          else
            toString replacements.${name};
      in
      lib.replaceStrings [ "@${name}@" ] [ replVal ] acc
    ) content (lib.attrNames replacements);
  mkTheme = pkgs.callPackage ./theme { inherit replaceVal; };
}
