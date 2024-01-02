{inputs, pkgs, ...}: {
  imports = [
    ./packages.nix
    ./programs.nix
    ./polkit-agent.nix
  ];
  home = {
    stateVersion = "23.11";
    username = "s4rch";
    homeDirectory = "/home/s4rch";
  };
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [inputs.fenix.overlays.default];
  wayland.windowManager.hyprland = import ../../../modules/hyprland;
  services.dunst = import ../../../modules/dunst{inherit pkgs;};
  services.easyeffects.enable = true;
}
