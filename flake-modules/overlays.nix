{ inputs, ... }:
let
  overlays = [
    (import ../pkgs)
    inputs.rust-overlay.overlays.default
    inputs.mac-style-plymouth.overlays.default
  ];
in
{
  flake.overlays.default = import ../pkgs;

  perSystem = { system, ... }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system overlays;
      config.allowUnfree = true;
    };
  };
}
