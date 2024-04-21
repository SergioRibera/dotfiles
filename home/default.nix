{ lib, config, inputs, ... }:
let
  inherit (config) user gui;
  inherit (user) username;
  guiImports = lib.optionals gui.enable [
    ./common/fonts.nix
  ];
in
{
  imports = [
    # ./${username} # Load home user configs
    # ../modules/nvim # TODO
    # ../modules/git # TODO
    ./common/time.nix
    ./common/network.nix
    ./common/xdg.nix
    ./common/virtualisation.nix
  ] ++ lib.optional (builtins.pathExists ./${username}) [ ./${username} ];

  users.users."${username}" = {
    inherit (user) isNormalUser;
    name = username;
    home = user.homepath;
  };

  nixpkgs.overlays = [ inputs.fenix.overlays.default ];
  home-manager.useGlobalPkgs = user.enableHM;
  home-manager.useUserPackages = user.enableHM;
  home-manager.users = lib.mkIf user.enableHM {
    "${username}" = { pkgs, config, ... }: {
      programs.home-manager.enable = user.enableHM;
      home = {
        inherit username;
        homeDirectory = user.homepath;
        stateVersion = user.osVersion;
        packages = import ./${username}/packages.nix { inherit pkgs; };
      };
    };
  };
}
