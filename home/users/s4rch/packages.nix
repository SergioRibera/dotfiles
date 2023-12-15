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
    statix
    jq
    delta
    neofetch
    flameshot
    rofi
    rofi-calc
    rofi-bluetooth
    xdg-utils
    wev
    brightnessctl

    # Bluetooth
    bluez
    blueman

    # Hyprland
    dunst
    hyprpicker
    swww
    # xwaylandvideobridge
    
    # Browser
    microsoft-edge
    firefox

    # GUI
    wezterm
    neovide
    pavucontrol
    font-manager
    obs-studio
  ];
}
