{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [ ./base.nix ];

  # User creation (home/ not included in server profile)
  users = {
    defaultUserShell = pkgs."${config.shell.name}";
    users."${config.user.username}" = {
      isNormalUser = config.user.isNormalUser;
      extraGroups = config.user.groups;
      shell = pkgs."${config.shell.name}";
    };
  };
  environment.shells = [
    pkgs.bashInteractive
    pkgs."${config.shell.name}"
  ];

  services.openssh.enable = lib.mkDefault true;

  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
}
