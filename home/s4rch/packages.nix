{ inputs, pkgs, lib, config, ... }: with pkgs;
[
  # Compresion
  ouch

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

  # python
  python3

  # cloudflare
  cloudflared
  nodePackages.wrangler

  # Docker
  docker-compose

  # Utils
  gitui
  scrcpy
  neofetch
  xdg-utils
  wev
  ntfs3g

  # Bluetooth
  # bluez
  # blueman

  # GUI
  neovide
  obs-studio

  # Social
  telegram-desktop
  # Discord
  discord
] ++ lib.optionals (pkgs.stdenv.buildPlatform.isLinux && config.gui.enable) [
  # Hyprland
  slurp
  wl-clipboard
  hyprpicker
  swww
  xwaylandvideobridge
  # inputs.self.packages.${pkgs.system}.hyprswitch

  # GUI
  feh
  warp
  neovide
  pavucontrol
  obs-studio
  screenkey

  # Icons
  papirus-icon-theme

  # Discord
  vesktop
]
