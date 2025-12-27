{ nixpkgs, ... }:
[
  "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-raspberrypi.nix"
  ./boot.nix
  {
    # Prioritize performance over efficiency
    powerManagement.cpuFreqGovernor = "performance";

    nvim = {
      neovide = false;
      complete = false;
    };

    shell = {
      name = "nushell";
      command = [ "nu" ];
      privSession = [
        "nu"
        "--no-history"
      ];
    };

    user = {
      isNormalUser = true;
      enableHM = true;
      groups = [
        "wheel"
        "docker"
        "networkmanager"
      ];
    };
  }
]
