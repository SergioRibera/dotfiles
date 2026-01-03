{
  pkgs,
  inputs,
  config,
  ...
}:
{
  environment.systemPackages =
    with pkgs;
    [
      inputs.agenix.packages.${pkgs.system}.default
      # Utils
      fd
      bat
      eza
      curl
      wget
      jq
      ripgrep
      bottom

      nix-output-monitor

      # ssl
      openssl

      # Compresion
      ouch

      # Utils
      gitui
      fastfetch
      kdePackages.ksshaskpass
    ]
    ++ pkgs.lib.optionals (config.nvim.complete) [
      wrkflw
      dive
      wormhole-rs

      # simple web server
      dufs

      # cloudflare
      cloudflared
      # nodePackages.wrangler

      # Docker
      docker-compose
    ];
}
