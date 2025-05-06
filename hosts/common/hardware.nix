{ pkgs, lib, config, ... }: {
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModulePackages = [ pkgs.linuxPackages.v4l2loopback ];
  hardware = {
    graphics = lib.mkIf config.gui.enable {
      enable = true;
      enable32Bit = true;
      # Vulkan
      extraPackages = with pkgs; [ mesa.drivers ];
    };
    bluetooth = lib.mkIf config.bluetooth {
      enable = true;
      powerOnBoot = false;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };
    };
  };
}
