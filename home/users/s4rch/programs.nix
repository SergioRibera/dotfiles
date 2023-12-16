{pkgs, ...}: {
    programs = {
        home-manager.enable = true;
        bat = import ../../../modules/bat {inherit pkgs;};
        fish = import ../../../modules/fish {inherit pkgs;};
        git = import ../../../modules/git {inherit pkgs;};
        rofi = import ../../../modules/rofi {inherit pkgs;};
        wezterm = import ../../../modules/wezterm {inherit pkgs;};
    };

    home = {
        pointerCursor = {
            gtk.enable = true;
            name = "Bibata-Modern-Ice";
            package = pkgs.bibata-cursors;
            size = 40;
        };
        # Iterate over script folder and make executable
        file = {
            ".local/bin/wallpaper" = {
                executable = true;
                source = ../../../scripts/wallpaper;
            };
            ".local/bin/volume" = {
                executable = true;
                source = ../../../scripts/volume;
            };
            ".local/bin/brightness" = {
                executable = true;
                source = ../../../scripts/brightness;
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
            ".ssh/config" = ''
Host github.com
    IdentifyFile ~/.ssh/github

Host gitlab.com
    IdentifyFile ~/.ssh/gitlab
            '';
        };
    };
}
