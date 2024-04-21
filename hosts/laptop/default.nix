{ inputs, ... }:
let
  username = "s4rch";
in
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = { inherit inputs; };
  modules = [
    ./hardware-configuration.nix
    ./boot.nix
    ../common
    ../../modules
    ../../home
    inputs.home-manager.nixosModules.home-manager
    {
      # Hardware
      networking.hostName = "nixos";

      # Prioritize performance over efficiency
      powerManagement.cpuFreqGovernor = "performance";

      gui.enable = true;

      user = {
        inherit username;
        isNormalUser = true;
        enableHM = true;
        enableMan = true;
        gitname = "Sergio Ribera";
        gitemail = "56278796+SergioRibera@users.noreply.github.com";
        groups = [ "wheel" "video" "audio" "docker" "networkmanager" "adbusers" "input" ];
      };
    }
  ];
}
