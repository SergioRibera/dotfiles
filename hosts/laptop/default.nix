{ inputs, ... }:
let
  username = "s4rch";
in
[
  inputs.grub2-themes.nixosModules.default
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

    shell = {
        name = "nushell";
        privSession = ["nu" "--no-history"];
    };

    user = {
        inherit username;
        isNormalUser = true;
        enableHM = true;
        browser = "chromium";
        groups = [ "wheel" "video" "audio" "docker" "networkmanager" "adbusers" "input" ];
    };
  }
]
