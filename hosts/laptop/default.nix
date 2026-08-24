{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  # Early KMS: amdgpu in initrd so Plymouth starts at native res from frame 1
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Prioritize performance over efficiency
  powerManagement.cpuFreqGovernor = "ondemand";

  git.enable = true;
  gui.enable = true;
  gui.touchpad = true;
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
    isNormalUser = true;
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
    ];
  };

  wm.screens = [
    {
      name = "eDP-1";
      resolution = {
        x = 1600;
        y = 900;
      };
    }
  ];

  services.xserver.videoDrivers = lib.optionals (
    pkgs.stdenv.buildPlatform.isLinux && config.gui.enable
  ) [ "amdgpu" ];

  hardware = {
    graphics = {
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
      ];
    };
  };
}
