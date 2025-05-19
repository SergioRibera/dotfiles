{ config, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];
  # Prioritize performance over efficiency
  powerManagement.cpuFreqGovernor = "performance";

  games = true;
  server-network = true;
  git.enable = true;
  gui.enable = true;
  sshKeys = true;
  audio = true;
  bluetooth = false;

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

  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.displayManager.gdm.wayland = true;
  boot.initrd.kernelModules = ["nvidia"];

  # Ethernet
  boot.extraModulePackages = with config.boot.kernelPackages; [ r8125 ];

  # boot = {
  #   initrd.kernelModules = ["nvidia"];
  #   kernelParams = ["nvidia-drm.modeset=1" "nvidia.NVreg_OpenRmEnableUnsupportedGpus=1"];
  # };
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaPersistenced = false;
    forceFullCompositionPipeline = true;
    open = true;
  };

  wm.actives = ["niri" "sway"];
  wm.screens = let
    height = 1080;
  in [
    { name = "DP-4"; rotation = "right"; }
    { name = "DP-3"; position.x = height; }
    {
      name = "DP-5";
      position = {
        x = height;
        y = height;
      };
    }
    {
      name = "HDMI-A-2";
      position.x = 3000;
      rotation = "right";
    }
  ];
}
