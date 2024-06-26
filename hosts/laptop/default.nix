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
    ../../home
    inputs.home-manager.nixosModules.home-manager
    {
      # Hardware
      networking.hostName = "nixos";

      # Prioritize performance over efficiency
      powerManagement.cpuFreqGovernor = "performance";

      git.enable = true;
      gui.enable = true;
      gui.touchpad = true;


      nvim = {
        enable = true;
        neovide = true;
        complete = true;
      };

      shell = {
        name = "nushell";
        privSession = ["nu" "--no-history"];
      };

      user = {
        inherit username;
        isNormalUser = true;
        enableHM = true;
        enableMan = false;
        browser = "chromium";
        groups = [ "wheel" "video" "audio" "docker" "networkmanager" "adbusers" "input" ];
      };
    }
  ];
}
