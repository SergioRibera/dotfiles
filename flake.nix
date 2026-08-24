{
  description = "SergioRibera NixOS System Configuration";

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      imports = [
        ./flake-modules/overlays.nix
        ./flake-modules/packages.nix
        ./flake-modules/containers.nix
        ./flake-modules/apps.nix
        ./flake-modules/devshells.nix
        ./flake-modules/formatter.nix
        ./flake-modules/hosts.nix
        ./flake-modules/isos.nix
        ./flake-modules/darwin.nix
      ];
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
    niri-pkg = {
      url = "github:SergioRibera/niri/own-niri-features";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hytale-launcher = {
      url = "github:swagtop/hytale-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-style-plymouth = {
      url = "github:SergioRibera/s4rchiso-plymouth-theme";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "fu";
    };
    sss = {
      url = "github:SergioRibera/sss";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.fenix.follows = "fenix";
      inputs.flake-utils.follows = "fu";
      inputs.crane.follows = "crane";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wallpapers = {
      url = "github:SergioRibera/wallpapers";
      flake = false;
    };
    hrtf-files = {
      url = "github:eadwu/HeSuVi-HRIRs";
      flake = false;
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    codebase-mm-mcp = {
      url = "github:DeusData/codebase-memory-mcp";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ansync = {
      url = "github:sbbw-widgets/ansync";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
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
      "https://niri.cachix.org"
      "https://sss.cachix.org"
      "https://anyrun.cachix.org"
      "https://cache.rustlang-es.org/main"
      "https://cache.sergioribera.rs/main"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "fufexan.cachix.org-1:LwCDjCJNJQf5XD2BV+yamQIMZfcKWR9ISIFy5curUsY="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "sss.cachix.org-1:YI2JMG95LEu62PC7VMz75N7bypEdUz9Z/Il1hkGH4AA="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      "main:NnVmqBjdfyyL4tGgoTw17lUMDgulJ75+67pOsJupnS4="
      "main:vFI3N1JP9edRFwBwdk9ebUKTIPWK9R1ECbkdA7Q593M="
    ];
  };
}
