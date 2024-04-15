{ pkgs, ... }:
let
  mac-style-src = pkgs.fetchFromGitHub {
    owner = "SergioRibera";
    repo = "s4rchiso-plymouth-theme";
    rev = "bc585b7f42af415fe40bece8192d9828039e6e20";
    sha256 = "sha256-yOvZ4F5ERPfnSlI/Scf9UwzvoRwGMqZlrHkBIB3Dm/w=";
  };
  mac-style-load = pkgs.callPackage mac-style-src { };
in
{
  boot = {
    tmp.cleanOnBoot = true;
    consoleLogLevel = 3;
    kernelParams = [
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
      grub.devices = ["nodev"];
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    plymouth = {
      enable = true;
      theme = "mac-style";
      themePackages = [ mac-style-load ];
    };
  };
}
