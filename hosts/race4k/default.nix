{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];
  # Prioritize performance over efficiency
  powerManagement.cpuFreqGovernor = "performance";

  ia.enable = true;
  games = true;
  server-network = true;
  git.enable = true;
  gui.enable = true;
  sshKeys = true;
  audio = true;
  bluetooth = false;

  nvim = {
    enable = true;
    neovide = true;
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
    groups = [ "wheel" "video" "audio" "docker" "libvirtd" "networkmanager" "adbusers" "input" "dialout" ];
  };

  services.xserver.videoDrivers = pkgs.lib.optionals
    (pkgs.stdenv.buildPlatform.isLinux && config.gui.enable)
    [ "nvidia" ];
  services.displayManager.gdm.wayland = true;

  # Ethernet
  boot.extraModulePackages = with config.boot.kernelPackages; [ r8125 ];

  environment = {
    systemPackages = [ pkgs.libva-utils ];
    variables = {
      NVD_BACKEND = "direct";
      LIBVA_DRIVER_NAME = "nvidia";
    };
  };
  boot = {
    initrd.kernelModules = ["nvidia"];
    kernelParams = ["rcutree.gp_init_delay=1"];
  };
  hardware = {
    nvidia-container-toolkit.enable = true;
    nvidia = {
      modesetting.enable = true;
      nvidiaPersistenced = false;
      powerManagement = {
        enable = true;
        finegrained = false;
      };
      forceFullCompositionPipeline = true;
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
       version = "575.64.05";
       sha256_64bit = "sha256-hfK1D5EiYcGRegss9+H5dDr/0Aj9wPIJ9NVWP3dNUC0=";
       sha256_aarch64 = "sha256-fYji1Y2vJc5t6dkqbh4AC/fuAswiIvlj2cXX4NmBunw=";
       openSha256 = pkgs.lib.fakeSha256;
       settingsSha256 = "sha256-o2zUnYFUQjHOcCrB0w/4L6xI1hVUXLAWgG2Y26BowBE=";
       persistencedSha256 = "sha256-2g5z7Pu8u2EiAh5givP5Q1Y4zk4Cbb06W37rf768NFU=";
      };
    };
  };

  wm.actives = ["niri" "jay"];
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
