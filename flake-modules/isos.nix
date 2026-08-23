{ inputs, ... }:
let
  hostLib = import ../lib/mk-host.nix { inherit inputs; };
  isoHosts = [
    {
      format = "iso";
      system = "x86_64-linux";
      name = "race4k";
    }
    {
      format = "iso";
      system = "x86_64-linux";
      name = "laptop";
    }
    {
      format = "sd";
      system = "aarch64-linux";
      name = "rpi";
    }
  ];
in
{
  perSystem = { system, ... }: {
    packages = builtins.listToAttrs (
      map (h: {
        name = h.name;
        value = inputs.nixos-generators.nixosGenerate (
          { format = h.format; } // (hostLib.mkHostArgs h.system h.name)
        );
      }) (builtins.filter (h: h.system == system) isoHosts)
    );
  };
}
