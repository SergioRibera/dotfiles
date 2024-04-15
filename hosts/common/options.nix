{ config
, pkgs
, ...
}:
let
  inherit (config) user;
in
{

  options.user = with pkgs.lib; {
    touchpad = mkEnableOption "Enable touchpad this host";
    enableHM = mkEnableOption "Enable home-manager this host";
    enableMan = mkEnableOption "Enable man pages this host";
    enableGUI = mkEnableOption "Enable gui for this host";
    osVersion = mkOption {
      type = types.str;
      default = "24.05";
    };
    username = mkOption {
      type = types.str;
    };
    gitname = mkOption {
      type = types.str;
    };
    gitemail = mkOption {
      type = types.str;
    };
    isNormalUser = mkOption {
      type = types.bool;
      default = true;
    };
    homepath = mkOption {
      type = types.str;
      default = "/home/${user.username}";
    };
    shell = mkOption {
      type = types.enum [ pkgs.fish pkgs.nushell ];
      default = pkgs.fish;
    };
    groups = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
  };

  config = {
    users.users."${user.username}" = {
      inherit (user) isNormalUser shell;
      extraGroups = user.groups;
      ignoreShellProgramCheck = true;
    };

    # home-manager.users = pkgs.lib.optionals user.enableHM {
    #   "${user.username}" = { pkgs, ... }: { };
    # };
  };
}
