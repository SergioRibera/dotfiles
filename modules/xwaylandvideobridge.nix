{ pkgs, self', ... }:
{
    home-manager.users.lemi.packages = [
        self'.packages.xwaylandvideobridge
    ];
}
