{ pkgs, inputs, system }:
let
  fishXdgConfig = pkgs.runCommand "fish-xdg-config" { } ''
    mkdir -p $out/config/fish
    cp ${./config.fish} $out/config/fish/config.fish
  '';
  drv = pkgs.writeShellScriptBin "fish" ''
    export XDG_CONFIG_HOME=${fishXdgConfig}/config
    exec ${pkgs.fish}/bin/fish "$@"
  '';
in
{
  type = "app";
  program = "${drv}/bin/fish";
  inherit drv;
}
