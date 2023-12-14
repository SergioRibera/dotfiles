{pkgs, ...}: {
    environment.sessionVariables = rec {
        PATH = [
            "$HOME/.cargo/bin/"
            "$HOME/.npm-global/bin"
        ];
    };
    environment.systemPackages = with pkgs; [
        # Default
        bat
        eza
        curl
        wget
        pkg-config

        # SSL
        openssl
        openssl.dev

        # Windows tools
        ntfs3g

        # Compression
        ouch

        # Predefined
        # Git
        git
        gitoxide

        # Bluetooth
        bluez

        # Utils
        ripgrep

        # Docker
        docker-compose
    ];
}
