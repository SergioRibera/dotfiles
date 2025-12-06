{
  description = "SergioRibera NixOS System Configuration";
  outputs =
    { nixpkgs, ... }@inputs:
    let
      # System types to support.
      systems = [
        "x86_64-linux"
        # "x86_64-darwin"
        "aarch64-linux"
        # "aarch64-darwin"
      ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      overlays = [
        (import ./pkgs)
        inputs.rust-overlay.overlays.default
        inputs.mac-style-plymouth.overlays.default
      ];
      forEachSystem = nixpkgs.lib.genAttrs systems;
      pkgs = forEachSystem (system:
        import nixpkgs {
          inherit system overlays;
          config.allowUnfree = true;
        }
      );
      mkLib = system: import ./lib {
        pkgs = pkgs.${system};
        inherit (nixpkgs) lib;
      };
      mkNixosCfg = username: system: name: inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          libx = mkLib system;
          hostName = name;
        } // (mkLib system);
        modules = [
          {
            # Hardware
            networking.hostName = name;
            nixpkgs.overlays = overlays;
            user.username = username;
          }
          ./home
          ./hosts/common
          inputs.agenix.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
        ] ++ [ ./hosts/${name} ];
      };
    in
    {
      overlays.default = import ./pkgs;
      # Just for Test
      packages = forEachSystem (system: let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in
        (import ./pkgs) pkgs pkgs);
      # packages = inputs.simplemoji.packages;
      # Contains my full system builds, including home-manager
      # nixos-rebuild switch --flake .#laptop
      nixosConfigurations = let
        username = "s4rch";
      in {
        race4k = mkNixosCfg username "x86_64-linux" "race4k";
        laptop = mkNixosCfg username "x86_64-linux" "laptop";
        rpi = mkNixosCfg username "aarch64-linux" "rpi";
      };

      # Programs that can be run by calling this flake
      apps = forEachSystem (system: (import ./apps { inherit system inputs; pkgs = pkgs.${system}; }));

      devShells = forEachSystem (system: let
          pkgs = import nixpkgs { inherit system; };
        in {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              inputs.quickshell.packages."${system}".default
              # TODO: disko implementation
              # disko.packages.${system}.default
              # git
              # nixos-generators
            ];
          };
        });
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    crane.url = "github:ipetkov/crane";
    fu.url = "github:numtide/flake-utils";
    flake-parts.url = "github:hercules-ci/flake-parts";
    zen-browser.url = "github:MarceColl/zen-browser-flake";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mango = {
      url = "github:DreamMaoMao/mango";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
    # wlrs-pkg.url = "git+file:///home/s4rch/Contributions/wlrs";
    niri-pkg.url = "git+file:///home/s4rch/Public/contributions/niri";
    # nixos-cosmic = {
    #   url = "github:lilyinstarlight/nixos-cosmic";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # hyprland ={
    #   url = "github:hyprwm/Hyprland";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # hyprspace = {
    #   url = "github:KZDKM/Hyprspace";
    #   # Hyprspace uses latest Hyprland. We declare this to keep them in sync.
    #   # inputs.hyprland.follows = "hyprland";
    # };
    # My plymouth theme
    mac-style-plymouth = {
      url = "github:SergioRibera/s4rchiso-plymouth-theme";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "fu";
    };
    # My tool to take screen/code screenshots
    sss = {
      url = "github:SergioRibera/sss";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.fenix.follows = "fenix";
      inputs.flake-utils.follows = "fu";
      inputs.crane.follows = "crane";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Dev Mode
    # sosd.url = "git+file:///home/s4rch/Projects/rust/soft_osd";
    sosd = {
      url = "github:SergioRibera/soft_osd";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nixificate my neovim configs
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Wallpapers
    wallpapers = {
      url = "github:SergioRibera/wallpapers";
      flake = false;
    };
    # Used to generate NixOS images for other platforms
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    builders-use-substitutes = true;
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://fufexan.cachix.org"
      "https://hyprland.cachix.org"
      "https://cosmic.cachix.org/"
      # I have problems with that
      # "https://cache.privatevoid.net"
      "https://niri.cachix.org"
      "https://sss.cachix.org"
      "https://anyrun.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "fufexan.cachix.org-1:LwCDjCJNJQf5XD2BV+yamQIMZfcKWR9ISIFy5curUsY="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
      # "cache.privatevoid.net:SErQ8bvNWANeAvtsOESUwVYr2VJynfuc9JRwlzTTkVg="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "sss.cachix.org-1:YI2JMG95LEu62PC7VMz75N7bypEdUz9Z/Il1hkGH4AA="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
    ];
  };
}
