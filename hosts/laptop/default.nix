{ ... }: [
  ./hardware-configuration.nix
  ./boot.nix
  {
    # Prioritize performance over efficiency
    powerManagement.cpuFreqGovernor = "performance";

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
  }
]
