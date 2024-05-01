{ pkgs, lib, config, ... }: {
  hardware = lib.mkIf config.gui.enable {
    opengl = {
      enable = true;
      # Vulkan
      driSupport = true;
      driSupport32Bit = true;
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
