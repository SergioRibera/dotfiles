{ pkgs, ... }: with pkgs;
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

  # Hyprland
  slurp
  wl-clipboard
  hyprpicker
  swww
  xwaylandvideobridge

  # GUI
  feh
  neovide
  pavucontrol
  obs-studio
  screenkey

  # Icons
  papirus-icon-theme

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
]
