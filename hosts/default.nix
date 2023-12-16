{ inputs
, withSystem
, sharedModules
, ...
}: {
  flake.nixosConfigurations =
    withSystem "x86_64-linux"
      ({ system
       , config
       , self'
       , ...
       }:
        let
          systemInputs = { _module.args = { inherit inputs; }; };
          inherit (inputs.nixpkgs.lib) nixosSystem;
          allowUnfree = { nixpkgs.config.allowUnfree = true; };
        in
        {
          laptop = nixosSystem {
            inherit system;
            modules = [
              ./laptop
              {
                  environment.shellAliases = {
                    ll = "eza -lh --icons --group-directories-first";
                    la = "eza -a --icons --group-directories-first";
                    lla = "eza -lah --icons";
                    llag = "eza -lah --git --icons";
                    ls = "eza -Gx --icons --group-directories-first";
                    lsr = "eza -Tlxa --icons --group-directories-first";
                    lsd = "eza -GDx --icons --color always";
                    cat = "bat";
                    nixclear = "nix-store --gc";
                    nixcleanup = "sudo nix-collect-garbage --delete-older-than 1d";
                    nixlistgen = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";
                    nixforceclean = "sudo nix-collect-garbage -d";
                  };
              #   environment.systemPackages = [ config.packages.xwaylandvideobridge ];
              }
            ];

            specialArgs = {
              inherit inputs;
            };
          };
        });
}
