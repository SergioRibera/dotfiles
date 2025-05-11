{ pkgs, lib, config, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];
  # Prioritize performance over efficiency
  powerManagement.cpuFreqGovernor = "performance";

  games = true;
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

  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.displayManager.gdm.wayland = true;
  boot.initrd.kernelModules = ["nvidia"];
  # boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11_beta ];
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaPersistenced = false;
    forceFullCompositionPipeline = true;
    # package = config.boot.kernelPackages.nvidiaPackages.beta;
    open = true;
    # powerManagement.enable = true;
    #prime = {
    #  sync.enable = true;
    #  amdgpuBusId = "PCI:0@0:73:0";
    #  nvidiaBusId = "PCI:0@0:01:0";
    #};
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
