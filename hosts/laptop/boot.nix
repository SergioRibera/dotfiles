{ inputs, pkgs, lib, config, ... }:
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

    initrd.supportedFilesystems = [ "ntfs" ];

    loader = {
      timeout = 3;
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
      };
    };

    plymouth = lib.mkIf gui.enable {
      enable = true;
      theme = "mac-style";
      themePackages = [ inputs.self.packages.${pkgs.system}.mac-style ];
    };
  };
}
