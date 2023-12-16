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
            ".config/script/volume" = {
                executable = true;
                source = ../../../scripts/volume;
            };
            ".config/script/brightness" = {
                executable = true;
                source = ../../../scripts/brightness;
            };
            ".config/script/battery-status" = {
                executable = true;
                source = ../../../scripts/battery-status;
            };
            ".cargo/config" = {
                executable = false;
                source = ../../../.cargo/config;
            };
            ".cargo/cargo-generate.toml" = {
                executable = false;
                source = ../../../.cargo/cargo-generate.toml;
            };
        };
    };
}
