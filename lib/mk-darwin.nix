{ inputs }:
let
  mkDarwin =
    { system, name, profile }:
    inputs.nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        inputs.home-manager.darwinModules.home-manager
        profile
        ../hosts/${name}
      ];
    };
in
{
  inherit mkDarwin;
}
