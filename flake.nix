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
      overlay = import ./pkgs;
      forEachSystem = nixpkgs.lib.genAttrs systems;
      pkgs = forEachSystem (system:
        import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [ overlay ];
        }
      );
      mkLib = system: import ./lib {
        pkgs = pkgs.${system};
        inherit (nixpkgs) lib;
      };
      mkNixosCfg = system: name: inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = rec {
          inherit inputs;
          libx = mkLib system;
          mkTheme = libx.mkTheme;
        };
        modules = [
          {
            # Hardware
            networking.hostName = name;
            nixpkgs.overlays = [ overlay ];
          }
          ./hosts/${name}/hardware-configuration.nix
          ./hosts/${name}/boot.nix
          ./hosts/common
          ./home
          inputs.agenix.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
        ] ++ (import ./hosts/${name} { inherit inputs; });
      };
    in
    {
      packages = pkgs;
      overlays.default = overlay;
      # Contains my full system builds, including home-manager
      # nixos-rebuild switch --flake .#laptop
      nixosConfigurations = {
        laptop = mkNixosCfg "x86_64-linux" "laptop";
        rpi = mkNixosCfg "aarch64-linux" "rpi";
      };

      # Programs that can be run by calling this flake
      apps = forEachSystem (system: (import ./apps { inherit system inputs; pkgs = pkgs.${system}; }));

      # For quickly applying home-manager settings with:
      # home-manager switch --flake .#s4rch
      # homeConfigurations = {
      #   s4rch = nixosConfigurations.laptop.config.home-manager.users.s4rch.home;
      #   s3rver = nixosConfigurations.rpi.config.home-manager.users.s3rver.home;
      # };

      # devShells."${system}".default = pkgs.mkShell {
      #   buildInputs = with pkgs; [
      #     # TODO: disko implementation
      #     # disko.packages.${system}.default
      #     git
      #     nixos-generators
      #   ];
      # };
    };

  inputs = {
    fenix.url = "github:nix-community/fenix";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    fu.url = "github:numtide/flake-utils";
    flake-parts.url = "github:hercules-ci/flake-parts";
    agenix.url = "github:ryantm/agenix";
    zen-browser.url = "github:MarceColl/zen-browser-flake";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    anyrun.url = "github:Kirottu/anyrun";
    wired = {
      url = "github:Toqozz/wired-notify";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri.url = "github:sodiboo/niri-flake";
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
    # My tool to take screen/code screenshots
    sss.url = "github:SergioRibera/sss";
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
