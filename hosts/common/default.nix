{ config, lib, ... }:
let
  inherit (config.user) username osVersion;
in
{
  imports = [
    ./secrets.nix
    ./boot.nix
    ./hardware.nix
    ./networks.nix
    ./options.nix
    ./packages.nix
    ./programs.nix
    ./services.nix
  ];

  environment.sessionVariables = {
    NH_FLAKE = "/etc/nixos";
  } // lib.optionalAttrs (config.gui.enable) {
    NIXOS_OZONE_WL = "1";
    ADW_DISABLE_PORTAL = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  nixpkgs.config.allowUnfree = true;
  documentation = {
    nixos.enable =  false;
    doc.enable = false;
  };
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
}
