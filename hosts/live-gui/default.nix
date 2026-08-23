{
  ...
}:
{
  gui.enable = true;
  gui.touchpad = true;
  audio = true;
  bluetooth = true;
  sshKeys = false;

  wm.actives = [ "niri" ];

  nvim = {
    enable = true;
    neovide = false;
    complete = false;
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
      "networkmanager"
      "input"
    ];
  };
}
