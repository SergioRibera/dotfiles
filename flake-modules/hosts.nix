{ inputs, ... }:
let
  hostLib = import ../lib/mk-host.nix { inherit inputs; };
  hosts = [
    {
      system = "x86_64-linux";
      name = "race4k";
      profile = ../profiles/desktop.nix;
    }
    {
      system = "x86_64-linux";
      name = "laptop";
      profile = ../profiles/desktop.nix;
    }
    {
      system = "aarch64-linux";
      name = "rpi";
      profile = ../profiles/desktop.nix;
    }
  ];
in
{
  flake.nixosConfigurations = builtins.listToAttrs (
    map (h: {
      name = h.name;
      value = hostLib.mkHost { inherit (h) system name profile; };
    }) hosts
  );
}
