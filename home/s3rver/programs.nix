{ config, ... }:
let
  inherit (config) user gui;
  shell = user.shell;
in
{
  programs = {
    # "${shell}".enable = true;
  };
}
