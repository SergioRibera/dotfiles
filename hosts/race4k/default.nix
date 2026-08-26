{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  services.ansync = {
    enable = true;
    user = config.user.username;
    package = inputs.ansync.packages.${pkgs.system}.default;
  };
  # Prioritize performance over efficiency
  powerManagement.cpuFreqGovernor = "performance";

  ia = {
    enable = true;
    service = true;
  };
  games = true;
  server-network = true;
  git.enable = true;
  sshKeys = true;
  audio = true;
  bluetooth = true;
  gui = {
    enable = true;
    touchpad = true;
  };

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
      "wpa_supplicant"
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
      "pcie_aspm=off"
    ];
    kernelPatches = [
      {
        name = "mt7925-bt-slpprot-fix";
        patch = ./mt7925-bt-slpprot.patch;
      }
    ];
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
      forceFullCompositionPipeline = false;
      # Switched to closed driver: open 595.71.05 has GSP RPC failures
      # (rpcSendMessage 0x0000000f / API_GPU_ATTACHED_SANITY_CHECK) that
      # cascade into libnvidia-eglcore abort → compositor freeze.
      open = false;
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
