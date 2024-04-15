{ pkgs, ... }: {

  imports = [
    ./hardware-configuration.nix
  ];

  user = {
    isNormalUser = false;
    username = "s3rver";
    cfgType = "minimal";
    shell = pkgs.fish;
    groups = [ "wheel" "docker" "networkmanager" "input" ];
  };
}
