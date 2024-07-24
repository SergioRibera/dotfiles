{pkgs, config, ... }: let
  inherit (config) shell user;
  nuPkg = (pkgs.nushell.overrideAttrs (prev: {
    doCheck = false;
  }));
in {
  system.userActivationScripts.nushell.text = with pkgs.nushellPlugins; ''
  ${nuPkg}/bin/nu -c "plugin add ${gstat}/bin/nu_plugin_gstat"
  ${nuPkg}/bin/nu -c "plugin use ${gstat}/bin/nu_plugin_gstat"
  '';

  home-manager.users."${user.username}".programs.nushell = {
    enable = (shell.name == "nushell");
    configFile.source = ./config.nu;
    envFile.source = ./env.nu;
    shellAliases = shell.aliases;
    package = nuPkg;
  };
}
