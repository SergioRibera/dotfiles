{
  shell,
  user,
  gui,
  pkgs,
  lib,
  ...
}:
let
  defaultShellExe = if shell.name == "nushell" then "nu" else shell.name;
  kdlList = items: lib.concatMapStringsSep " " (a: ''"${a}"'') items;
  privCmd = builtins.head shell.privSession;
  privArgs = builtins.tail shell.privSession;

  configKdl = pkgs.writeText "zellij-config.kdl" (
    ''
      default_shell "${defaultShellExe}"
    ''
    + builtins.readFile ./config.kdl
  );

  privateLayout = pkgs.writeText "zellij-private.kdl" ''
    layout {
      default_tab_template {
        pane size=1 borderless=true {
          plugin location="zellij:tab-bar"
        }
        children
      }
      pane {
        command "${privCmd}"
        ${lib.optionalString (privArgs != [ ]) "args ${kdlList privArgs}"}
      }
    }
  '';

  themeTpl = pkgs.writeText "zellij-theme.kdl.tmpl" (builtins.readFile ./theme.kdl.tmpl);

  matugenCfg = pkgs.writeText "zellij-matugen.toml" ''
    [templates.zellij]
    input_path = "${themeTpl}"
    output_path = "${user.homepath}/.config/zellij/themes/dms.kdl"
  '';

  fallbackTheme =
    let
      c = gui.theme.colors;
    in
    pkgs.writeText "zellij-dms-fallback.kdl" ''
      themes {
          dms {
              fg      "${c.base05}"
              bg      "${c.base00}"
              black   "${c.base00}"
              red     "${c.base08}"
              green   "${c.base0B}"
              yellow  "${c.base0A}"
              blue    "${c.base0D}"
              magenta "${c.base0E}"
              cyan    "${c.base0C}"
              white   "${c.base05}"
              orange  "${c.base09}"
          }
      }
    '';
in
{
  inherit
    configKdl
    privateLayout
    themeTpl
    matugenCfg
    fallbackTheme
    ;
  pkg = pkgs.zellij;
  layoutsDir = ./layouts;
  homepath = user.homepath;
}
