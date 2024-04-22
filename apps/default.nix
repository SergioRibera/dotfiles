{ pkgs, ... }: rec {
  # Show quick helper as default
  default = help;
  help = import ./help.nix { inherit pkgs; };

  # Rebuild
  rebuild = import ./rebuild.nix { inherit pkgs; };

  # Run neovim as an app
  nvim = import ./neovim.nix { inherit pkgs; complete = true; };

  # Run neovim as an app
  nvim-basic = import ./neovim.nix { inherit pkgs; complete = false; };
}
