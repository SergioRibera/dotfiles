{ config, lib, ... }:
let
  inherit (config.user) username osVersion;
  makeSecret = name: {
    "${name}" = {
      file = ../../secrets/${name}.age;
      owner = username;
      group = "wheel";
    };
  };
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
  console.useXkbConfig = true;

  networking.networkmanager.enable = true;

  environment.shellAliases = config.shell.aliases;
  services.getty.autologinUser = username;

  age.secrets = (makeSecret "github")
    // (makeSecret "rustlanges")
    // (makeSecret "hosts");
}
