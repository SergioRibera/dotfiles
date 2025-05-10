{ pkgs, lib, config, ... }:
let
  inherit (config) gui;
in
{
  boot = {
    consoleLogLevel = 0;
    tmp.cleanOnBoot = true;
    kernelParams = lib.optionals gui.enable [
      "quiet"
      "splash"
      "rd.systemd.show_status=auto"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "boot.shell_on_fail"
    ];

    initrd = {
      verbose = false;
      supportedFilesystems = [ "ntfs" ];
    };

    loader = {
      timeout = 3;
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };

    plymouth = lib.mkIf gui.enable {
      enable = true;
      theme = "mac-style";
      themePackages = [ pkgs.mac-style ];
    };
  };
}
