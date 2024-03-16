{ pkgs, config, ... }: {
  programs = {
    home-manager.enable = true;
    ssh.enable = true;
    gpg = {
      enable = true;
      homedir = "${config.xdg.dataHome}/gnupg";
    };
    bat = import ../../../modules/bat { inherit pkgs; };
    fish = import ../../../modules/fish { inherit pkgs; };
    git = import ../../../modules/git { inherit pkgs; };
    rofi = import ../../../modules/rofi { inherit pkgs; };
    wezterm = import ../../../modules/wezterm { inherit pkgs; };
    sss = import ../../../modules/sss.nix;
  };

  services = {
    swayosd = import ../../../modules/swayosd { inherit pkgs; };

    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentryFlavor = "gnome3";
    };
  };

  home = {
    pointerCursor = {
      gtk.enable = true;
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };
    # Iterate over script folder and make executable
    file = {
      ".local/bin/wallpaper" = {
        executable = true;
        source = ../../../scripts/wallpaper;
      };
      ".local/bin/hyprshot" = {
        executable = true;
        source = ../../../scripts/hyprshot;
      };
      ".cargo/config" = {
        executable = false;
        source = ../../../.cargo/config;
      };
      ".cargo/cargo-generate.toml" = {
        executable = false;
        source = ../../../.cargo/cargo-generate.toml;
      };
      ".ssh/config".text = ''
        AddKeysToAgent yes

        Host github.com
            IdentityFile ~/.ssh/github

        Host gitlab.com
            IdentityFile ~/.ssh/gitlab
      '';
    };
  };
}
