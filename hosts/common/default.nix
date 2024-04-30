{ config, ... }:
let
  inherit (config.user) osVersion;
in
{
  imports = [ ./packages.nix ./options.nix ];
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
    ga = "git add -A && git commit -m";
    gs = "git switch";
    gsc = "git switch -c";
    glg = "git lg";
    nixdev = "nix develop -c 'fish'";
    nixclear = "nix-store --gc";
    nixcleanup = "sudo nix-collect-garbage --delete-older-than 1d";
    nixlistgen = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";
    nixforceclean = "sudo nix-collect-garbage -d";
  };
}
