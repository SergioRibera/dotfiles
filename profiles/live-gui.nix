{
  config,
  lib,
  ...
}:
{
  imports = [ ./desktop.nix ];

  # Autologin — live session starts directly
  services.getty.autologinUser = lib.mkForce config.user.username;

  # No persistent secrets in a live ISO
  age.secrets = lib.mkForce { };
}
