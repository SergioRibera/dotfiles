{ inputs, pkgs, ... }: rec {
  # Show quick helper as default
  default = help;
  help = import ./help.nix { inherit pkgs; };
  fmt = {
    type = "app";
    program = "${pkgs.writeShellScript "fmt-all" ''
      find . -name '*.nix' -type f -exec ${pkgs.nixfmt-rfc-style}/bin/nixfmt {} \;
    ''}";
  };

  # Build
  rebuild = import ./rebuild.nix { inherit pkgs; };
  update-pkgs = import ./update-pkgs { inherit pkgs; };

  # Run neovim as an app
  nvim = import ./neovim.nix { inherit inputs pkgs; complete = true; };

  # Run neovim as an app
  nvim-basic = import ./neovim.nix { inherit inputs pkgs; complete = false; };
}
