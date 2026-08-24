{
  lib,
  ...
}:
{
  gui.enable = false;
  audio = false;
  bluetooth = false;
  sshKeys = false;

  # Disk layout for nixos-anywhere installs on generic VPS (KVM, /dev/vda)
  # Override disko.devices.disk.main.device per-deploy if needed.
  disko.devices.disk.main = {
    type = "disk";
    device = lib.mkDefault "/dev/vda";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "512M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };
        root = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
      };
    };
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
      "networkmanager"
    ];
  };

  # No host-specific secrets for the appliance ISO
  age.secrets = lib.mkForce { };
}
