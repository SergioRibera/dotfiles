{
  imports = [
    ./boot.nix
    ./environment.nix
    ./packages.nix
    ./programs.nix
    ./services.nix
    ./hardware.nix
  ];

  sound.enable = true;
}
