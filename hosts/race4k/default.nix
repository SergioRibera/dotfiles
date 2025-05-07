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
