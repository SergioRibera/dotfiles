{ pkgs, ... }: with pkgs;
[
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
]
