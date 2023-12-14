{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules
    ../../home
  ];

  laptop = {
    isNormalUser = true;
    username = "s4rch";
    shell = pkgs.fish;
    groups = ["wheel" "video" "audio" "docker" "networkmanager"];
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = " 23.05 "; # Did you read the comment?
}
