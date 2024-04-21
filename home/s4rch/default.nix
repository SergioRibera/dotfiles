{
  imports = [
    ./environment.nix
    ./programs.nix
    ./services.nix
    ./hardware.nix
  ];

  sound.enable = true;
}
