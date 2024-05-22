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

  i18n.defaultLocale = "en_US.UTF-8";
  environment.shellAliases = {
    ll = "eza -lh --icons --group-directories-first";
    la = "eza -a --icons --group-directories-first";
    lla = "eza -lah --icons";
    llag = "eza -lah --git --icons";
    ls = "eza -Gx --icons --group-directories-first";
    lsr = "eza -Tlxa --icons --group-directories-first";
    lsd = "eza -GDx --icons --color always";
    cat = "bat";
    catn = "bat --plain";
    catnp = "bat --plain --paging=never";
    ga = "git add -A && git commit -m";
    gs = "git s";
    gb = "git switch";
    gp = "git p";
    gbc = "git switch -c";
    glg = "git lg";
    tree = "eza --tree --icons=always";
    nixdev = "nix develop -c 'fish'";
    nixclear = "nix-store --gc";
    nixcleanup = "sudo nix-collect-garbage --delete-older-than 1d";
    nixlistgen = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";
    nixforceclean = "sudo nix-collect-garbage -d";
  };

  services.getty.autologinUser = username;
}
