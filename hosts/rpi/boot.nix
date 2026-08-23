{ lib, config, ... }:
let
  inherit (config) gui;
in
{
  boot = {
    consoleLogLevel = 3;
    tmp.cleanOnBoot = true;
    kernelParams = lib.optionals gui.enable [
      "quiet"
      "splash"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "boot.shell_on_fail"
    ];

    initrd = {
      systemd.enable = lib.mkDefault true;
      supportedFilesystems = [ "ntfs" ];
    };

    # Disable EFI bootloader — RPi uses extlinux via sd-image module
    loader = {
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = lib.mkForce false;
      grub.enable = lib.mkForce false;
    };
  };
}
