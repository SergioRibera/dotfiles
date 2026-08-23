{ inputs, ... }:
let
  hostLib = import ../lib/mk-host.nix { inherit inputs; };
  isoHosts = [
    {
      format = "iso";
      system = "x86_64-linux";
      name = "race4k";
      profile = ../profiles/desktop.nix;
    }
    {
      format = "iso";
      system = "x86_64-linux";
      name = "laptop";
      profile = ../profiles/desktop.nix;
    }
    {
      format = "sd";
      system = "aarch64-linux";
      name = "rpi";
      profile = ../profiles/server.nix;
    }
    {
      format = "iso";
      system = "x86_64-linux";
      name = "server-iso";
      profile = ../profiles/server.nix;
    }
    {
      format = "iso";
      system = "x86_64-linux";
      name = "live-gui";
      profile = ../profiles/live-gui.nix;
    }
  ];
in
{
  perSystem = { system, ... }: {
    packages = builtins.listToAttrs (
      map (h: {
        name = h.name;
        value = inputs.nixos-generators.nixosGenerate (
          { format = h.format; } // (hostLib.mkHostArgs { inherit (h) system name profile; })
        );
      }) (builtins.filter (h: h.system == system) isoHosts)
    );
  };
}
