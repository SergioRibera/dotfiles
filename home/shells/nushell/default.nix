{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (config) shell user;
  nuPkg = (
    pkgs.nushell.overrideAttrs (prev: {
      doCheck = false;
    })
  );
in
{
  system.userActivationScripts.nushell.text =
    with pkgs.nushellPlugins;
    lib.optionalString (shell.name == "nushell") ''
      ${nuPkg}/bin/nu -c "plugin add ${gstat}/bin/nu_plugin_gstat"
      ${nuPkg}/bin/nu -c "plugin use ${gstat}/bin/nu_plugin_gstat"
    '';

  home-manager.users."${user.username}" = {
    xdg = lib.mkIf (pkgs.stdenv.buildPlatform.isLinux) {
      configFile."nushell/prompt.nu" = lib.mkIf (config.shell.name == "nushell") {
        source = ./prompt.nu;
      };
      configFile."nushell/ggit.nu" = lib.mkIf (config.shell.name == "nushell") {
        source = ./ggit.nu;
      };
      configFile."nushell/carapace.nu" = lib.mkIf (config.shell.name == "nushell") {
        source = ./carapace.nu;
      };
    };
    programs.nushell = {
      enable = (shell.name == "nushell");
      configFile.source = ./config.nu;
      envFile.source = ./env.nu;
      shellAliases = shell.aliases;
      package = nuPkg;
    };
  };
}
