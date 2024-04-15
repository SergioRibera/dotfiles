{ config, pkgs, ... }:
let
  inherit (config) user;
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
  ] ++ pkgs.lib.optionals user.enableGUI [
    ./common/fonts.nix
  ];

  programs.home-manager.enable = user.enableHM;

  # homeConfigurations.${user.username} = home-manager.lib.homeManagerConfiguration {
  #   inherit pkgs;

  #   programs.home-manager.enable = user.enableHM;
  #   home = {
  #     stateVersion = user.osVersion;
  #     inherit (user) username;
  #     homeDirectory = user.homepath;
  #   };
  # };

  # home-manage.users.${user.username} = {}: {
  #   home = {
  #     stateVersion = user.osVersion;
  #     inherit (user) username;
  #     homeDirectory = user.homepath;
  #   };
  # };

  home = {
    stateVersion = user.osVersion;
    inherit (user) username;
    homeDirectory = user.homepath;
  };

  manual = {
    json.enable = false;
    html.enable = false;
    manpages.enable = user.enableMan;
  };
}
