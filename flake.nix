{
  description = "SergioRibera NixOS System Configuration";
  outputs = { nixpkgs, ... }@inputs:
    let
      # System types to support.
      supportedSystems = [
        "x86_64-linux"
        # "x86_64-darwin"
        "aarch64-linux"
        # "aarch64-darwin"
      ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      # forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    inputs.flake-parts.lib.mkFlake
      {
        inherit inputs;
      }
      {
        systems = supportedSystems;
        imports = [ ./hosts ];

        # packages =
        #   let
        #     neovim =
        #       system:
        #       let
        #         pkgs = import nixpkgs { inherit system; };
        #       in
        #       import ./modules/nvim {
        #         inherit pkgs;
        #         colors = (import ./colorscheme/gruvbox-dark).dark;
        #       };
        #   in
        #   {
        #     # Package Neovim config into standalone package
        #     x86_64-linux.neovim = neovim "x86_64-linux";
        #     x86_64-darwin.neovim = neovim "x86_64-darwin";
        #     aarch64-linux.neovim = neovim "aarch64-linux";
        #     aarch64-darwin.neovim = neovim "aarch64-darwin";
        #   };

        # # Programs that can be run by calling this flake
        # apps = forAllSystems (
        #   system:
        #   let
        #     pkgs = import nixpkgs { inherit system; };
        #   in
        #   import ./apps { inherit pkgs; }
        # );
      };

  inputs = {
    fenix = {
      url = "github:nix-community/fenix";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    sss.url = "github:SergioRibera/sss";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://helix.cachix.org"
      "https://fufexan.cachix.org"
      "https://hyprland.cachix.org"
      "https://cache.privatevoid.net"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "fufexan.cachix.org-1:LwCDjCJNJQf5XD2BV+yamQIMZfcKWR9ISIFy5curUsY="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "cache.privatevoid.net:SErQ8bvNWANeAvtsOESUwVYr2VJynfuc9JRwlzTTkVg="
    ];
  };
}
