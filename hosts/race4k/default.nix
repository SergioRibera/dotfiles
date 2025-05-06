{ pkgs, lib, config, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];
  # Prioritize performance over efficiency
  powerManagement.cpuFreqGovernor = "performance";

  git.enable = true;
  gui.enable = true;
  sshKeys = true;
  audio = true;
  bluetooth = true;

  nvim = {
    enable = false;
    neovide = false;
    complete = true;
  };

  terminal = {
    name = "alacritty";
    command = ["alacritty" "-e"];
  };
  shell = {
    name = "nushell";
    command = ["nu"];
    privSession = ["nu" "--no-history"];
  };

  user = {
    isNormalUser = true;
    enableHM = true;
    browser = "firefox";
    groups = [ "wheel" "video" "audio" "docker" "libvirtd" "networkmanager" "adbusers" "input" ];
  };

  services.xserver.videoDrivers = lib.optionals
    (pkgs.stdenv.buildPlatform.isLinux && config.gui.enable)
    [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaPersistenced = true;
    forceFullCompositionPipeline = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    open = false;
  };

  wm.screens = [];
}
