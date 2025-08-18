{ pkgs, lib, config, ... }:
let
  inherit (config) gui wm;
  mkRotation = rot: if rot == "left" then "270" else if rot == "right" then "90" else if rot == "inverted" then "180" else "0";
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
    ] ++ (builtins.map (o: "video=${o.name}:${builtins.toString o.resolution.x}x${builtins.toString o.resolution.y}@${builtins.toString o.frequency},rotate=${mkRotation o.rotation}") wm.screens);

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
