{ inputs, self, ... }:
let
  inherit (inputs.nixpkgs.lib) nixosSystem;
in
{
  flake.nixosConfigurations = {
    # Main computer
    laptop = nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs self;
      };

      modules = [
        inputs.home-manager.nixosModules.home-manager
        ./common
        ./laptop
        ../home
      ];
    };

    # Raspberry Server
    s3rver = nixosSystem {
      system = "aarch64-linux";
      specialArgs = {
        inherit inputs self;
      };

      modules = [
        inputs.home-manager.nixosModules.home-manager
        ./common
        ./s3rver
      ];
    };
  };
}
