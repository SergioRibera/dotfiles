{ config, ... }: let
  inherit (config) user;
in {
  imports = [
    ./terminal
  ];
}
