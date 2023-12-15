{
    config,
    pkgs,
    ...
}: let
    laptop = config.laptop;
in {
    imports = [
        # ./nvim
        ./boot.nix
        ./environment.nix
        ./fonts.nix
        ./hardware.nix
        ./network.nix
        ./programs.nix
        ./services.nix
        ./virtualisation.nix
        ./xdg.nix
    ];

    options.laptop = with pkgs.lib; {
        username = mkOption {
            type = types.str;
        };
        isNormalUser = mkOption {
            type = types.bool;
            default = true;
        };
        homepath = mkOption {
            type = types.str;
            default = "/home/${laptop.username}";
        };
        shell = mkOption {
            type = types.enum [pkgs.bash pkgs.zsh pkgs.fish];
            default = pkgs.fish;
        };
        groups = mkOption {
            type = types.listOf types.str;
            default = [];
        };
    };

    # sound.enable = true;
    # time.timeZone = "America/La_Paz";

    config = {
        users.users."${laptop.username}" = {
            isNormalUser = laptop.isNormalUser;
            extraGroups = laptop.groups;
        };
    };
}
