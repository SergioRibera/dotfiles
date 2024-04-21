{ config, ... }:
let
  inherit (config) user;
in
{
  # imports = [ ./bat ];

  home-manager.users.${user.username} = { pkgs, lib, ... }: {
    programs = {
      bat = import ./bat { inherit pkgs config; };
    };
  };
}
