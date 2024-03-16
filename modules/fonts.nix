{ pkgs, ... }: {
    fonts = {
        fontDir.enable = true;
        packages = with pkgs; [
            noto-fonts noto-fonts-color-emoji
            noto-fonts-cjk-sans noto-fonts-lgc-plus
            (nerdfonts.override { fonts = [ "CascadiaCode" "FiraCode" "UbuntuMono" ]; })
        ];
    };
}
