{ config, lib, ... }:
let
  inherit (config.user) username osVersion;
in
{
  imports = [
    ./hardware.nix
    ./options.nix
    ./packages.nix
    ./programs.nix
    ./services.nix
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = lib.optionalString (config.gui.enable) "1";

  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    warn-dirty = false;
    auto-optimise-store = true;
    builders-use-substitutes = true;
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "@wheel" ];
  };

  system.stateVersion = osVersion;

  time.timeZone = "America/La_Paz";
  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
    };
  };

  environment.shellAliases = config.shell.aliases;
  services.getty.autologinUser = username;
}
