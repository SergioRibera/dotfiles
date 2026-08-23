{ inputs, pkgs, ... }:
let
  nvim = inputs.nixvim.legacyPackages.${pkgs.system}.makeNixvim (
    import ./module.nix {
      inherit inputs pkgs;
      user.username = "user";
      cfg = { enable = true; neovide = false; complete = false; };
      gui = { enable = false; theme = { name = "gruvbox-dark"; colors = (import ../../colorscheme/gruvbox-dark).dark; }; };
      shell = { name = "nushell"; command = [ "nu" ]; };
    }
  );
in
pkgs.dockerTools.buildLayeredImage {
  name = "nvim";
  tag = "latest";
  contents = [ nvim pkgs.git pkgs.coreutils ];
  config = {
    Entrypoint = [ "${nvim}/bin/nvim" ];
    Env = [ "TERM=xterm-256color" ];
  };
}
