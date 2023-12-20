{
    config,
    pkgs,
    ...
}: let
    inherit (config) laptop;
in {
    imports = [
        ./nvim
        ./boot.nix
        ./environment.nix
        ./fonts.nix
        ./hardware.nix
        ./network.nix
        ./programs.nix
        ./services.nix
        ./sound.nix
        ./time.nix
        ./virtualisation.nix
        ./xdg.nix
        # ./xwaylandvideobridge.nix
    ];

    options.laptop = with pkgs.lib; {
        username = mkOption {
            type = types.str;
        };
        cfgType = mkOption {
            type = types.enum ["minimal" "complete"];
            default = "minimal";
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

    config = {
        users.users."${laptop.username}" = {
            inherit (laptop) isNormalUser;
            inherit (laptop) shell;
            extraGroups = laptop.groups;
        };
    };
}
