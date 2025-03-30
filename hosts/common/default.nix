{ inputs, config, lib, ... }:
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

  environment.sessionVariables = lib.optionalAttrs (config.gui.enable){
    NIXOS_OZONE_WL = "1";
    WLR_DRM_DEVICES = "/dev/dri/card0:/dev/dri/card1:/dev/dri/card2";
  };

  nixpkgs.config.allowUnfree = true;
  nix = {
    # pin the registry to avoid downloading and evaling a new nixpkgs version every time
    # registry = lib.mapAttrs (_: v: {flake = v;}) inputs;
    # set the path for channels compat
    # nixPath = lib.mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;

    settings = {
      warn-dirty = false;
      auto-optimise-store = true;
      builders-use-substitutes = true;
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
      # flake-registry = "/etc/nix/registry.json";

      # for direnv GC roots
      # keep-derivations = true;
      # keep-outputs = true;
    };
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
