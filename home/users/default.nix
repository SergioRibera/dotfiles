{
  pkgs,
  inputs,
  lib,
  ...
}: {
  home-manager.users = {
    s4rch = import ./s4rch {
      inherit pkgs inputs lib;
    };
  };
}
