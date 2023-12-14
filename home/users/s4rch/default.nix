{inputs, ...}: {
  imports = [
    ./packages.nix
    ./programs.nix
  ];
  home = {
    stateVersion = "23.05";
    username = "s4rch";
    homeDirectory = "/home/s4rch";
  };
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [inputs.fenix.overlays.default];
  wayland.windowManager.hyprland = import ../../../modules/hyprland;
}
