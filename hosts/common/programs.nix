{ lib, config, pkgs, ... }:
let
  inherit (config) shell user gui age;
  inherit (age) secrets;
  inherit (pkgs.stdenv.buildPlatform) isLinux;
in {
  programs = {
    fish.enable = shell.name == "fish";
    dconf.enable = (isLinux && gui.enable);
    virt-manager.enable = (isLinux && gui.enable);
    xwayland.enable = (isLinux && gui.enable);
    nh = lib.mkIf user.enableHM {
      enable = true;
      flake = "/etc/nixos";
    };
    direnv = lib.mkIf user.enableHM {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
      loadInNixShell = true;
    };
    ssh = {
      extraConfig = ''
        AddKeysToAgent yes
        Host github.com
            IdentityFile ${secrets.github.path}
        Host gitlab.com
            IdentityFile ~/.ssh/gitlab
      '';
    };
    adb.enable = config.nvim.complete;
  };
}
