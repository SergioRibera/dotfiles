{ inputs, pkgs, lib, config, ... }: with pkgs; [
  # Compresion
  ouch

  # python
  python3

  # cloudflare
  cloudflared
  nodePackages.wrangler

  # Docker
  docker-compose

  # Utils
  gitui
  neofetch
  ntfs3g
] ++ lib.optionals config.gui.enable [
  # GUI
  chromium

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
] ++ lib.optionals (pkgs.stdenv.buildPlatform.isLinux && config.gui.enable) [
  # Hyprland
  grim
  slurp
  libnotify
  wl-clipboard
  hyprpicker
  swww
  xwaylandvideobridge
  # (import ./wm/dwl.nix { inherit inputs pkgs config; })
  # inputs.self.packages.${pkgs.system}.hyprswitch

  # GUI
  feh
  warp
  pavucontrol
  screenkey

  # Icons
  papirus-icon-theme

  # Discord
  vesktop
] ++ lib.optionals (config.nvim.neovide && config.gui.enable) [ neovide ]
