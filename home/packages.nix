{ hostName, pkgs, lib, config, ... }: let
  inherit (config.user) username;

  tomlFormat = pkgs.formats.toml {};
in
with pkgs; { home-manager.users."${username}" = {
  xdg.configFile."bottom/bottom.toml".source = tomlFormat.generate "bottom.toml" {
    flags = {
      dot_marker = true;
      enable_gpu = true;
    };
    processes = {
      tree = true;
      group_processes = false;
      process_memory_as_value = true;
      columns = ["PID" "Name" "CPU%" "Mem%" "R/s" "W/s" "User" "State" "GMem%" "GPU%"];
    };
  };

  home.packages = [
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
    fastfetch

    # self overlay
    simple-commits
  ] ++ lib.optionals (config.gui.enable && hostName == "race4k") [
    # Social
    telegram-desktop

    # Work
    slack
    figma-linux
    onlyoffice-desktopeditors

    # Utils
    scrcpy
    xdg-utils
    wev
  ] ++ lib.optionals config.nvim.complete [
    wrkflw
    dive
    just

    # Js
    pnpm
    nodejs

    # C/C++ Develoment
    clang

    # Rust Develoment
    rust-bin.stable.latest.default
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
  ] ++ lib.optionals (pkgs.stdenv.buildPlatform.isLinux && config.gui.enable && config.nvim.complete) [
    quickemu
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
    swaynotificationcenter

    # GUI
    easyeffects
    pwvucontrol
    anydesk
    simplemoji

    nautilus

    # Discord
    (discord.overrideAttrs (final: prev: {
      withOpenASAR = true;
      commandLineArgs = "--use-gl=desktop";
    }))
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
  ++ lib.optionals (config.bluetooth && config.gui.enable) [ overskride ]
  ++ lib.optionals (config.bluetooth && !config.gui.enable) [ bluetui ]
  ++ lib.optionals config.games [
    prismlauncher # minecraft launcher
    mcpelauncher-ui-qt
    heroic
    lutris
  ];
};}
