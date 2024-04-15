{ pkgs, ... }: {

  imports = [
    ./hardware-configuration.nix
  ];

  # home-manager.useGlobalPkgs = true;
  # home-manager.useUserPackages = true;

  user = {
    isNormalUser = true;
    enableHM = true;
    enableMan = true;
    enableGUI = true;
    username = "s4rch";
    gitname = "Sergio Ribera";
    gitemail = "56278796+SergioRibera@users.noreply.github.com";
    shell = pkgs.fish;
    groups = [ "wheel" "video" "audio" "docker" "networkmanager" "adbusers" "input" ];
  };
}
