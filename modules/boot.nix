{ pkgs, ... }: let
    mac-style-src = pkgs.fetchFromGitHub {
      owner = "SergioRibera";
      repo = "s4rchiso-plymouth-theme";
      rev = "bc585b7f42af415fe40bece8192d9828039e6e20";
      sha256 = "sha256-yOvZ4F5ERPfnSlI/Scf9UwzvoRwGMqZlrHkBIB3Dm/w=";
    };
    mac-style-load = pkgs.callPackage mac-style-src {};
in {
  boot = {
    tmp.cleanOnBoot = true;
    supportedFilesystems = [ "ntfs" "btrfs" ];
    kernelParams = [
      "quiet" "splash" "rd.systemd.show_status=false" "rd.udev.log_level=3"
      "udev.log_priority=3" "boot.shell_on_fail"
    ];

    loader = {
      systemd-boot.enable = false;
      timeout = 0;

      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
      };
    };

    plymouth = {
      enable = true;
      theme = "mac-style";
      themePackages = [ mac-style-load ];
    };
  };
}
