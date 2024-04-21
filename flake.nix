{
  description = "SergioRibera NixOS System Configuration";
  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      # System types to support.
      systems = [
        "x86_64-linux"
        # "x86_64-darwin"
        "aarch64-linux"
        # "aarch64-darwin"
      ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forEachSystem = nixpkgs.lib.genAttrs systems;
      nixpkgsFor = forEachSystem (system:
        import nixpkgs { inherit system; }
      );
    in
    {
      packages = forEachSystem (system:
        import ./pkgs { pkgs = nixpkgsFor.${system}; }
      );
      # Contains my full system builds, including home-manager
      # nixos-rebuild switch --flake .#laptop
      nixosConfigurations = {
        laptop = import ./hosts/laptop { inherit inputs; };
        rpi = import ./hosts/rpi { inherit inputs; };
      };

      # For quickly applying home-manager settings with:
      # home-manager switch --flake .#s4rch
      # homeConfigurations = {
      #   s4rch = nixosConfigurations.laptop.config.home-manager.users.s4rch.home;
      #   s3rver = nixosConfigurations.rpi.config.home-manager.users.s3rver.home;
      # };
    };

  inputs = {
    fenix.url = "github:nix-community/fenix";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    fu.url = "github:numtide/flake-utils";
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
