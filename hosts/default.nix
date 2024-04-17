{ inputs, self, config, ... }:
let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  specialArgs = {
    inherit inputs config self;
  };
in
{
  flake.nixosConfigurations = {
    # Main computer
    laptop = nixosSystem {
      system = "x86_64-linux";
      inherit specialArgs;

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
      inherit specialArgs;

      modules = [
        inputs.home-manager.nixosModules.home-manager
        ./common
        ./s3rver
        ../home
      ];
    };
  };
}
