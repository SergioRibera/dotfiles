{
  lib,
  ...
}:
{
  gui.enable = false;
  audio = false;
  bluetooth = false;
  sshKeys = false;

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
      "networkmanager"
    ];
  };

  # No host-specific secrets for the appliance ISO
  age.secrets = lib.mkForce { };
}
