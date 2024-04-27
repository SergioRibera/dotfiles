{ pkgs ? import <nixpkgs> { }, ... }: {
  mac-style = pkgs.callPackage ./plymouth-macstyle { };
  hyprswitch = pkgs.callPackage ./hyprswitch { };

  # Nvim Extra Plugins
  nvim-surround = pkgs.callPackage ./nvim/surround.nix { inherit pkgs; };
  nvim-lsp-progress = pkgs.callPackage ./nvim/lsp-progress.nix { inherit pkgs; };
  nvim-wakatime = pkgs.callPackage ./nvim/wakatime.nix { inherit pkgs; };

  nvim-cmp-dotenv = pkgs.callPackage ./nvim/cmp-dotenv.nix { inherit pkgs; };
  nvim-codeshot = pkgs.callPackage ./nvim/codeshot.nix { inherit pkgs; };
}
