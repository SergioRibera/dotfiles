{ lib, config, ... }:
let
  inherit (config) user;
  home = {
    stateVersion = user.osVersion;
    inherit (user) username;
    homeDirectory = user.homepath;
  };
in
{
  imports = [
    "./${user.username}" # Load home user configs
    ../modules/nvim # TODO
    ../modules/git # TODO
    ./common/time.nix
    ./common/network.nix
    ./common/xdg.nix
    ./common/virtualisation.nix
  ] ++ lib.optionals user.enableGUI [
    ./common/fonts.nix
  ];

  inherit home;
  programs.home-manager.enable = user.enableHM;
  home-manager.useGlobalPkgs = user.enableHM;
  home-manager.useUserPackages = user.enableHM;


  # homeConfigurations.${user.username} = home-manager.lib.homeManagerConfiguration {
  #   inherit pkgs;

  #   programs.home-manager.enable = user.enableHM;
  #   home = {
  #     stateVersion = user.osVersion;
  #     inherit (user) username;
  #     homeDirectory = user.homepath;
  #   };
  # };

  manual = {
    json.enable = false;
    html.enable = false;
    manpages.enable = user.enableMan;
  };

  home-manager.users = lib.optionals user.enableHM {
    inherit home;
    "${user.username}" = { pkgs, ... }: { };
  };
}
