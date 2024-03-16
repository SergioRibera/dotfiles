{ pkgs, ... }: {
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
    trunk
    cargo-make
    cargo-expand
    cargo-generate
    cargo-dist

    # python
    python3

    # Web Develoment
    nodePackages.tailwindcss

    # Utils
    gitui
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
    screenkey
    poedit

    # Icons
    papirus-icon-theme

    # Audio plugins
    easyeffects

    # Social
    telegram-desktop
    # Discord
    vesktop
    ((discord.override {
      nss = pkgs.nss_latest;
      withOpenASAR = true;
      withVencord = true;
    }).overrideAttrs (old: {
      libPath = old.libPath + ":${pkgs.libglvnd}/lib";
      nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.makeWrapper ];

      postFixup = ''
        wrapProgram $out/opt/Discord/Discord --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland}}"
      '';
    }))

  ];
}
