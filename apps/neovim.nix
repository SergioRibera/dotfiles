{ inputs, pkgs, complete, ... }:
let
  src = (inputs.nixvim.legacyPackages.${pkgs.system}.makeNixvim (import ../modules/nvim/package {
    inherit pkgs;
    user = {
      username = "sergioribera";
    };
    cfg = {
      enable = true;
      neovide = complete;
      complete = complete;
    };
    gui = {
      enable = complete;
      theme = {
        name = "gruvbox-dark";
        colors = (import ../colorscheme/gruvbox-dark).dark;
      };
    };
  }));

  bin = if complete then "${src}/bin/neovide" else "${src}/bin/nvim";
in
{
  type = "app";
  program = bin;
}
