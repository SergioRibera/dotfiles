{ modulesPath, ... }:
{
  imports = [
    "${modulesPath}/installer/sd-card/sd-image-raspberrypi.nix"
    ./boot.nix
  ];

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
    enableHM = false;
    groups = [
      "wheel"
      "docker"
      "networkmanager"
    ];
  };

  # No secrets on headless rpi build
  age.secrets = { };
}
