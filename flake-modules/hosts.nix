{ inputs, ... }:
let
  hostLib = import ../lib/mk-host.nix { inherit inputs; };
  hosts = [
    {
      system = "x86_64-linux";
      name = "race4k";
    }
    {
      system = "x86_64-linux";
      name = "laptop";
    }
    {
      system = "aarch64-linux";
      name = "rpi";
    }
  ];
in
{
  flake.nixosConfigurations = builtins.listToAttrs (
    map (h: {
      name = h.name;
      value = hostLib.mkHost h.system h.name;
    }) hosts
  );
}
