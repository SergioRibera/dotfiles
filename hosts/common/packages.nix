{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # Utils
    fd
    bat
    eza
    curl
    wget
    jq
    ripgrep
    bottom

    # ssl
    openssl
  ];
}
