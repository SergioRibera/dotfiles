{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (config) gui wm;
  mkRotation =
    rot:
    if rot == "left" then
      "270"
    else if rot == "right" then
      "90"
    else if rot == "inverted" then
      "180"
    else
      "0";
in
{
  boot = {
    consoleLogLevel = lib.mkDefault 0;
    tmp.cleanOnBoot = lib.mkDefault true;
    kernelParams =
      lib.optionals gui.enable [
        "quiet"
        "splash"
        "rd.systemd.show_status=auto"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
        "boot.shell_on_fail"
      ]
      ++ (builtins.map (
        o:
        "video=${o.name}:${builtins.toString o.resolution.x}x${builtins.toString o.resolution.y}@${builtins.toString o.frequency},rotate=${mkRotation o.rotation}"
      ) wm.screens);

    initrd = {
      verbose = lib.mkDefault false;
      supportedFilesystems = lib.mkDefault [ "ntfs" ];
    };

    loader = {
      timeout = lib.mkDefault 3;
      efi.canTouchEfiVariables = lib.mkDefault true;
      systemd-boot.enable = lib.mkDefault true;
    };

    plymouth = lib.mkIf gui.enable {
      enable = true;
      theme = "mac-style";
      themePackages = [ pkgs.mac-style-plymouth ];
    };
  };
}
