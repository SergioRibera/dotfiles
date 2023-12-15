{ pkgs, self', ... }:
{
    home-manager.users.s4rch.packages = [
        self'.packages.xwaylandvideobridge
    ];
}
