{ inputs, config, ... }:
{
  wsl = {
    enable = true;
    defaultUser = config.user.username;
  };

  gui.enable = false;
  audio = false;
  bluetooth = false;

  nvim = {
    enable = true;
    neovide = false;
    complete = true;
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
    groups = [
      "wheel"
      "docker"
    ];
  };

  # No host-specific secrets for WSL
  age.secrets = { };
}
