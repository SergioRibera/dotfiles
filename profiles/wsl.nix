{
  lib,
  ...
}:
{
  imports = [
    ./base.nix
    ../home
  ];

  # WSL2: no bootloader — systemd-boot is invalid in WSL
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
  boot.loader.timeout = lib.mkForce null;
}
