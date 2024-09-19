{ inputs, ... }:
let
  username = "s4rch";
in
[
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
        browser = "zen";
        groups = [ "wheel" "video" "audio" "docker" "networkmanager" "adbusers" "input" ];
    };
  }
]
