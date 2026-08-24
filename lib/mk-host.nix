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
    {
      system,
      name,
      profile ? ../profiles/desktop.nix,
      extraModules ? [ ],
    }:
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
        profile
        inputs.agenix.nixosModules.default
        inputs.home-manager.nixosModules.home-manager
        inputs.ansync.nixosModules.default
        inputs.disko.nixosModules.disko
      ]
      ++ extraModules
      ++ [ ../hosts/${name} ];
    };

  mkHost = args: inputs.nixpkgs.lib.nixosSystem (mkHostArgs args);
in
{
  inherit mkHostArgs mkHost;
}
