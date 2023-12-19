{pkgs, ...}: {
  home.packages = with pkgs; [
    # Js
    bun
    nodejs

    # C/C++ Develoment
    gcc_multi

    # Rust Develoment
    fenix.stable.toolchain
    cargo-leptos
    leptosfmt
    cargo-make
    trunk

    # python
    python3

    # Web Develoment
    nodePackages.tailwindcss

    # Social
    telegram-desktop
    discord

    # Utils
    scrcpy
    statix
    jq
    neofetch
    xdg-utils
    wev

    # Bluetooth
    bluez
    blueman

    # Hyprland
    grim
    slurp
    wl-clipboard
    hyprpicker
    swww
    xwaylandvideobridge
    
    # Browser
    microsoft-edge

    # GUI
    feh
    neovide
    pavucontrol
    font-manager
    obs-studio

    # Icons
    papirus-icon-theme

    # Audio plugins
    easyeffects
  ];
}
