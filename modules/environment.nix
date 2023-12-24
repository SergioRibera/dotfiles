{pkgs, ...}: {
    environment.sessionVariables = {
        PATH = [
            "$HOME/.cargo/bin/"
            "$HOME/.npm-global/bin"
        ];
    };
    environment.systemPackages = with pkgs; [
        # Default
        fd
        eza
        curl
        wget
        htop
        pkg-config

        # SSL
        openssl
        openssl.dev

        # Windows tools
        ntfs3g

        # Compression
        ouch

        # Git
        gitoxide

        # Bluetooth
        bluez

        # Utils
        ripgrep

        # Docker
        docker-compose
    ];
}
