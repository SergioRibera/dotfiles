{ inputs, pkgs, complete, ... }:
let
  src = (inputs.nixvim.legacyPackages.${pkgs.system}.makeNixvim (import ../home/editors/nvim {
    inherit inputs pkgs;
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
    shell = {
      name = "nushell";
      command = ["nu"];
    };
  }));

  script = pkgs.writeShellScriptBin "run-neovide" ''
    ${pkgs.neovide}/bin/neovide --neovim-bin ${src}/bin/nvim
  '';
in
{
  type = "app";
  program = if complete then
      "${script}/bin/run-neovide"
    else
      "${src}/bin/nvim";
}
