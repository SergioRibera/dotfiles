{ inputs }:
let
  username = "s4rch";
  overlays = [
    (import ../pkgs)
    inputs.rust-overlay.overlays.default
    inputs.mac-style-plymouth.overlays.default
  ];

  mkLib =
    system:
    import ./. {
      pkgs = import inputs.nixpkgs { inherit system overlays; config.allowUnfree = true; };
      inherit (inputs.nixpkgs) lib;
    };

  mkHostArgs =
    system: name:
    {
      inherit system;
      specialArgs = {
        inherit inputs;
        libx = mkLib system;
        hostName = name;
      }
      // (mkLib system);
      modules = [
        {
          networking.hostName = name;
          nixpkgs.overlays = overlays;
          user.username = username;
          boot.binfmt.emulatedSystems =
            (import inputs.nixpkgs { inherit system; }).lib.optionals (system != "aarch64-linux") [
              "aarch64-linux"
            ];
        }
        ../home
        ../hosts/common
        inputs.agenix.nixosModules.default
        inputs.home-manager.nixosModules.home-manager
        inputs.ansync.nixosModules.default
      ]
      ++ [ ../hosts/${name} ];
    };

  mkHost = system: name: inputs.nixpkgs.lib.nixosSystem (mkHostArgs system name);
in
{
  inherit mkHostArgs mkHost;
}
