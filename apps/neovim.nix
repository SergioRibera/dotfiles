{ inputs, pkgs, complete, ... }:
let
  src = (import ../modules/nvim/package {
    inherit inputs pkgs;
    lib = pkgs.lib;
    user = { };
    cfg = {
      enable = true;
      neovide = complete;
      complete = complete;
    };
    gui = {
      theme = {
        name = "gruvbox-dark";
        colors = (import ../colorscheme/gruvbox-dark).dark;
      };
    };
  });

  bin = if complete then "${src}/bin/neovide" else "${src}/bin/nvim";
in
{
  type = "app";
  program = bin;
}
