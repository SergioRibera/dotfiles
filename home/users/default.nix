{
  pkgs,
  inputs,
  lib,
  ...
}: {
  home-manager.sharedModules = [
    inputs.sss.nixosModules.home-manager
  ];
  home-manager.users = {
    s4rch = import ./s4rch {
      inherit pkgs inputs lib;
    };
  };
}
