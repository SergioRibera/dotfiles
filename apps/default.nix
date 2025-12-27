{ inputs, pkgs, ... }:
rec {
  # Show quick helper as default
  default = help;
  help = import ./help.nix { inherit pkgs; };
  wallpaper-path = {
    type = "app";
    program = builtins.toString (
      pkgs.writeShellScript "show-wallpaper-path" ''
        echo -e "${inputs.wallpapers}"
      '');
  };

  # Build
  rebuild = import ./rebuild.nix { inherit pkgs; };
  update-pkgs = import ./update-pkgs { inherit pkgs; };

  # Run neovim as an app
  nvim = import ./neovim.nix {
    inherit inputs pkgs;
    complete = true;
  };

  # Run neovim as an app
  nvim-basic = import ./neovim.nix {
    inherit inputs pkgs;
    complete = false;
  };
}
