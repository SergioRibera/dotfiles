{ inputs, ... }:
let
  username = "s3rver";
in
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = { inherit inputs; };
  modules = [
    ./hardware-configuration.nix
    ./boot.nix
    ../common
    ../../home
    inputs.home-manager.nixosModules.home-manager
    {
      # Hardware
      networking.hostName = "nixos";

      # Prioritize performance over efficiency
      powerManagement.cpuFreqGovernor = "performance";

      nvim = {
        neovide = false;
        complete = false;
      };

      user = {
        inherit username;
        isNormalUser = true;
        enableHM = true;
        groups = [ "wheel" "docker" "networkmanager" "input" ];
      };
    }
  ];
}
