{ pkgs ? import <nixpkgs> { }, ... }: rec {
  mac-style = pkgs.callPackage ./plymouth-macstyle { };
  hyprswitch = pkgs.callPackage ./hyprswitch { };
  scenefx = pkgs.callPackage ./scenefx { };

  # Nvim Extra Plugins
  nvim-surround = pkgs.callPackage ./nvim/surround.nix { inherit pkgs; };
  nvim-lsp-progress = pkgs.callPackage ./nvim/lsp-progress.nix { inherit pkgs; };
  nvim-wakatime = pkgs.callPackage ./nvim/wakatime.nix { inherit pkgs; };

  nvim-cmp-dotenv = pkgs.callPackage ./nvim/cmp-dotenv.nix { inherit pkgs; };
  nvim-codeshot = pkgs.callPackage ./nvim/codeshot.nix { inherit pkgs; };

  # Cosmic
  libcosmicAppHook = pkgs.callPackage ./cosmic/libcosmic-app-hook { inherit pkgs; };
  cosmic-files = pkgs.callPackage ./cosmic/files { inherit libcosmicAppHook pkgs; };
  xdg-desktop-portal-cosmic = pkgs.callPackage ./cosmic/xdg-portal { inherit libcosmicAppHook pkgs; };
}
