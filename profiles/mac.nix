{ inputs, pkgs, lib, config, ... }:
let
  username = "s4rch";
  ctx = {
    shell = {
      name = "nushell";
      command = [ "nu" ];
      privSession = [ "nu" "--no-history" ];
    };
    user = {
      username = username;
      homepath = "/Users/${username}";
      enableHM = true;
      osVersion = "26.05";
    };
    gui = {
      enable = false;
      theme.colors = { };
    };
    inherit pkgs lib;
  };
in
{
  users.users.${username} = {
    home = "/Users/${username}";
    shell = pkgs.nushell;
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${username} =
    { lib, ... }:
    {
      programs.home-manager.enable = true;
      home = {
        inherit username;
        homeDirectory = "/Users/${username}";
        stateVersion = "25.05";
      };
    }
    // (import ../tools/nvim/hm.nix {
      inherit pkgs lib inputs;
      ctx = ctx // {
        cfg = {
          enable = true;
          neovide = false;
          complete = true;
        };
        gui = {
          enable = false;
          theme = {
            name = "gruvbox-dark";
            colors = (import ../colorscheme/gruvbox-dark).dark;
          };
        };
      };
    })
    // (import ../tools/fish/hm.nix { inherit pkgs lib inputs ctx; })
    // (import ../tools/zellij/hm.nix { inherit pkgs lib inputs ctx; });
}
