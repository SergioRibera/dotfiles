{pkgs, config, lib}: {
  enable = true;
  configFile.source = ./config.nu;
  envFile.source = ./env.nu;
  shellAliases = config.shell.aliases;
}
