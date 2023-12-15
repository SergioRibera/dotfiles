{pkgs, ...}: {
    programs = {
        # bat = import ../../../modules/bat {inherit pkgs;};
        # eza = import ../../../modules/eza {inherit pkgs;};
        # feh = import ../../../modules/feh;
        # git = import ../../../modules/git {inherit pkgs;};
        # htop = import ../../../modules/htop {inherit pkgs;};
        # ripgrep = import ../../../modules/ripgrep;
        # rofi = import ../../../modules/rofi {inherit pkgs;};
        home-manager.enable = true;
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
        };
    };
}
