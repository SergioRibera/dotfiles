{ pkgs ? import <nixpkgs> { }, ... }: rec {
  mac-style = pkgs.callPackage ./plymouth-macstyle { };
  hyprswitch = pkgs.callPackage ./hyprswitch { };
  scenefx = pkgs.callPackage ./scenefx { };

  # Nvim Extra Plugins
  nvim-surround = pkgs.callPackage ./nvim/surround.nix { };
  nvim-lsp-progress = pkgs.callPackage ./nvim/lsp-progress.nix { };
  nvim-wakatime = pkgs.callPackage ./nvim/wakatime.nix { };

  nvim-cmp-dotenv = pkgs.callPackage ./nvim/cmp-dotenv.nix { };
  nvim-codeshot = pkgs.callPackage ./nvim/codeshot.nix { };

  # Utils
  simple-commits = pkgs.callPackage ./simple-commits { };

  # Cosmic
  libcosmicAppHook = pkgs.callPackage ./cosmic/libcosmic-app-hook { };
  cosmic-files = pkgs.callPackage ./cosmic/files { inherit libcosmicAppHook; };
  xdg-desktop-portal-cosmic = pkgs.callPackage ./cosmic/xdg-portal { inherit libcosmicAppHook; };
}
