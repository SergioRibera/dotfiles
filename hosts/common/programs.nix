{ lib, config, pkgs, ... }:
let
  inherit (config) shell user gui;
  inherit (pkgs.stdenv.buildPlatform) isLinux;
in {
  programs = {
    fish.enable = shell.name == "fish";
    dconf.enable = (isLinux && gui.enable);
    xwayland.enable = (isLinux && gui.enable);
    nh = lib.mkIf user.enableHM {
      enable = true;
      flake = "/etc/nixos";
    };
    ssh = {
      startAgent = true;
      extraConfig = ''
        AddKeysToAgent yes

        Host github.com
            IdentityFile ~/.ssh/github

        Host gitlab.com
            IdentityFile ~/.ssh/gitlab
      '';
    };
    adb.enable = config.nvim.complete;
    thunar = {
      enable = gui.enable;
      plugins = [ ];
    };

    # firefox = lib.mkIf
    #   (gui.enable && user.browser == "firefox")
    #   (import ./browser/firefox.nix { inherit lib pkgs config; });
    chromium = lib.mkIf
      (gui.enable && user.browser == "chromium")
      (import ../../home/desktop/browser/chromium.nix { inherit config; });
  };
}
