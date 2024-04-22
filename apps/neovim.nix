{ pkgs, complete, ... }:
let
  src = (import ../modules/nvim/package {
    inherit pkgs;
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

  bin = if complete then "${pkgs.neovide}/bin/neovide" else "${pkgs.neovim}/bin/nvim";
in
{
  type = "app";
  program = bin;
}
