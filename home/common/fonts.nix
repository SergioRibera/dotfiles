{ pkgs, lib, config, ... }: {
  fonts = lib.mkIf (config.gui.enable || pkgs.stdenv.buildPlatform.isDarwin) {
    fontDir.enable = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      noto-fonts-lgc-plus
      (nerdfonts.override { fonts = [ "CascadiaCode" "FiraCode" "UbuntuMono" ]; })
    ];
  };
}
