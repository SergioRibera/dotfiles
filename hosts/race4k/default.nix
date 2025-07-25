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
    groups = [ "wheel" "video" "audio" "docker" "libvirtd" "networkmanager" "adbusers" "input" "dialout" ];
  };

  services.xserver.videoDrivers = pkgs.lib.optionals
    (pkgs.stdenv.buildPlatform.isLinux && config.gui.enable)
    [ "nvidia" ];
  services.xserver.displayManager.gdm.wayland = true;

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
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaPersistenced = false;
    powerManagement = {
      enable = true;
      finegrained = false;
    };
    forceFullCompositionPipeline = true;
    open = false;
    # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    #  version = "550.163.01";
    #  sha256_64bit = "sha256-74FJ9bNFlUYBRen7+C08ku5Gc1uFYGeqlIh7l1yrmi4=";
    #  sha256_aarch64 = "sha256-fYji1Y2vJc5t6dkqbh4AC/fuAswiIvlj2cXX4NmBunw=";
    #  openSha256 = "";
    #  settingsSha256 = "sha256-fYji1Y2vJc5t6dkqbh4AC/fuAswiIvlj2cXX4NmBunw=";
    #  persistencedSha256 = "";
    # };
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
