{ pkgs, config, ... }: let
    user = config.laptop;
in{
    home-manager.users."${user.username}".xdg = {
        enable = true;
        userDirs = {
            enable = true;
            music = null;
            desktop = null;
            publicShare = null;
            createDirectories = true;
        };
    };
    xdg.portal = {
        enable = true;
        wlr.enable = true;
        xdgOpenUsePortal = true;
        config.common.default = ["gtk"];
        extraPortals = with pkgs; [ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];
    };
}
