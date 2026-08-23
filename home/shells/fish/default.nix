{ config, ... }:
{
  home-manager.users."${config.user.username}".programs.fish =
    import ../../../tools/fish/module.nix { inherit (config) shell; };
}
