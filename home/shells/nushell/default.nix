{pkgs, config, lib}: {
  enable = true;
  configFile.source = ./config.nu;
}
