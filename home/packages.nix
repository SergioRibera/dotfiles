{ hostName, pkgs, lib, config, ... }: let
  inherit (config.user) username;
in
with pkgs; {
  home-manager.users."${username}".home.packages = [
    # Compresion
    ouch

    # simple web server
    dufs

    # cloudflare
    cloudflared
    # nodePackages.wrangler

    # Docker
    docker-compose

    # Utils
    gitui
    neofetch
    ntfs3g

    # self overlay
    simple-commits
    # inputs.cartero.packages.${pkgs.system}.default
  ] ++ lib.optionals (config.gui.enable && hostName == "race4k") [
    # Social
    telegram-desktop

    # Utils
    scrcpy
    xdg-utils
    wev
  ] ++ lib.optionals config.nvim.complete [
    # Js
    bun
    nodejs

    # C/C++ Develoment
    gcc_multi

    # Rust Develoment
    fenix.stable.toolchain
    leptosfmt
    trunk

    # Cargo extras
    cargo-make
    cargo-leptos
    cargo-expand
    cargo-generate
    cargo-dist
    cargo-release
    cargo-machete
  ] ++ lib.optionals (pkgs.stdenv.buildPlatform.isLinux && config.gui.enable) [
    distrobox
    evsieve
    brightnessctl

    # Wayland
    grim
    slurp
    libnotify
    wl-clipboard
    wl-mirror
    hyprpicker
    swww
    kdePackages.xwaylandvideobridge

    # GUI
    pavucontrol
    anydesk

    # self overlay
    cosmic-files

    # Icons
    papirus-icon-theme

    # Discord
    discord
    # Dorion Client: Rust + Tauri
    # https://github.com/SpikeHD/Dorion
    # WebRTC Support explained here: https://github.com/tauri-apps/tauri/discussions/8426#discussioncomment-8268622
    # dorion
    # (dorion.overrideAttrs (final: prev: {
    #   buildInputs = prev.buildInputs ++ [
    #     (webkitgtk_4_1.overrideAttrs (final: prev: {
    #       doCheck = false;
    #       cmakeFlags = prev.cmakeFlags ++ [
    #         "-DENABLE_MEDIA_STREAM=ON"
    #         "-DENABLE_WEB_RTC=ON"
    #       ];
    #       buildInputs = prev.buildInputs ++ [ openssl ];
    #       # GIO_MODULE_DIR = "${glib-networking}/lib/gio/modules";
    #     }))
    #   ];
    # }))
  ]
  ++ lib.optionals (config.nvim.neovide && config.gui.enable) [ neovide ]
  ++ lib.optionals config.games [
    prismlauncher # minecraft launcher
  ];
}
