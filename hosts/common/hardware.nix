{ pkgs, lib, config, ... }: {
  hardware = lib.mkIf config.gui.enable {
    graphics = {
      enable = true;
      enable32Bit = true;
      # Vulkan
      extraPackages = with pkgs; [
        amdvlk
        mesa.drivers
        rocmPackages.clr.icd
      ];
      # For 32 bit applications
      extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk
      ];
    };
  };
}
