{ pkgs, inputs, system }:
let
  configKdl = pkgs.writeText "zellij-config.kdl" (
    ''
      default_shell "nu"
    ''
    + builtins.readFile ./config.kdl
  );
  drv = pkgs.writeShellScriptBin "zellij" ''
    exec ${pkgs.zellij}/bin/zellij --config ${configKdl} "$@"
  '';
in
{
  type = "app";
  program = "${drv}/bin/zellij";
  inherit drv;
}
