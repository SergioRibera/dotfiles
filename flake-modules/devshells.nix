{ inputs, ... }:
{
  perSystem = { system, ... }: {
    devShells.default =
      let
        pkgs = import inputs.nixpkgs { inherit system; };
      in
      pkgs.mkShell {
        buildInputs = [
          # quickshell removed: not a declared flake input
        ];
      };
  };
}
