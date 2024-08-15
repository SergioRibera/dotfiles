{ pkgs, inputs, ... }: {
  environment.systemPackages = with pkgs; [
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

    # ssl
    openssl
  ];
}
