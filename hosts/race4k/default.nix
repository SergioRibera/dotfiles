{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];
  # Prioritize performance over efficiency
  powerManagement.cpuFreqGovernor = "performance";

  ia = {
    enable = true;
    service = true;
  };
  games = true;
  server-network = true;
  git.enable = true;
  gui.enable = true;
  sshKeys = true;
  audio = true;
  bluetooth = true;

  nvim = {
    enable = true;
    neovide = true;
    complete = true;
  };

  terminal = {
    name = "alacritty";
    command = [
      "alacritty"
      "-e"
    ];
  };
  shell = {
    name = "nushell";
    command = [ "nu" ];
    privSession = [
      "nu"
      "--no-history"
    ];
  };

  user = {
    enableHM = true;
    browser = "firefox";
    groups = [
      "wheel"
      "video"
      "audio"
      "docker"
      "libvirtd"
      "networkmanager"
      "adbusers"
      "input"
      "dialout"
    ];
  };

  services.xserver.videoDrivers = pkgs.lib.optionals (
    pkgs.stdenv.buildPlatform.isLinux && config.gui.enable
  ) [ "nvidia" ];
  services.displayManager.gdm.wayland = true;

  # Ethernet
  boot.extraModulePackages = with config.boot.kernelPackages; [ r8125 ];
  boot.blacklistedKernelModules = [
    "r8169"
    "amdgpu"
    "radeon"
  ];

  environment = {
    systemPackages = with pkgs; [
      libva-utils
      vulkan-tools
    ];
    variables = {
      # NVD_BACKEND = "direct";
      LIBVA_DRIVER_NAME = "nvidia";
    };
  };
  boot = {
    initrd.kernelModules = [ "nvidia" ];
    kernelParams = [
      "rcutree.gp_init_delay=1"
      "mt7925e.disable_aspm=1"
      "nvidia_drm.modeset=1"
      "nvidia_drm.fbdev=1"
      "module_blacklist=amdgpu,radeon"
    ];
  };
  hardware = {
    nvidia-container-toolkit.enable = false;
    nvidia = {
      modesetting.enable = true;
      nvidiaPersistenced = false;
      powerManagement = {
        enable = true;
        finegrained = false;
      };
      forceFullCompositionPipeline = false;
      # Open kernel modules. RTX 3060 = Ampere (GA106), fully
      # supported by `nvidia-open` since 555.x. The open path has the
      # saner DRM/KMS implementation and is what NVIDIA is going to
      # maintain going forward — no reason to stay on the closed
      # `nvidia.ko` for a consumer Ampere card.
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.production;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        libva
        vulkan-loader
        vulkan-validation-layers
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        libva
      ];
    };
  };

  wm.actives = [
    "niri"
  ];
  wm.screens =
    let
      height = 1080;
    in
    [
      {
        name = "DP-2";
        rotation = "left";
      }
      {
        name = "DP-1";
        position.x = height;
      }
      {
        name = "DP-3";
        position = {
          x = height;
          y = height;
        };
      }
      {
        name = "HDMI-A-1";
        position.x = 3000;
        rotation = "right";
      }
    ];
}
