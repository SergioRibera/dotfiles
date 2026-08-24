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
      profile = ../profiles/server.nix;
    }
    {
      system = "x86_64-linux";
      name = "wsl";
      profile = ../profiles/wsl.nix;
      extraModules = [ inputs.nixos-wsl.nixosModules.wsl ];
    }
    # nixos-anywhere target: boot VPS into rescue mode, then:
    # nix run github:nix-community/nixos-anywhere -- --flake .#server-iso root@<ip>
    {
      system = "x86_64-linux";
      name = "server-iso";
      profile = ../profiles/server.nix;
    }
  ];
in
{
  flake.nixosConfigurations = builtins.listToAttrs (
    map (h: {
      name = h.name;
      value = hostLib.mkHost {
        inherit (h) system name profile;
        extraModules = h.extraModules or [ ];
      };
    }) hosts
  );
}
