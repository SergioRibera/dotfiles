{ pkgs ? import <nixpkgs> { }, ... }: {
  mac-style = pkgs.callPackage ./plymouth-macstyle { };
  hyprswitch = pkgs.callPackage ./hyprswitch { };
}
