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
      systemd.enable = true;
      supportedFilesystems = [ "ntfs" ];
    };

    loader = {
      timeout = 0;
      grub.devices = [ "nodev" ];
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
