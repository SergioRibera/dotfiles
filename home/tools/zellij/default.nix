{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config)
    gui
    user
    shell
    ;
  inherit (user) username;

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
        children
      }
      pane {
        command "${privCmd}"
        ${lib.optionalString (privArgs != [ ]) ''args ${kdlList privArgs}''}
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
  config = lib.mkIf gui.enable {
    # WM "open terminal" binds wrap the shell with zellij. nvim's term-split
    # keeps using shell.command (raw shell) so it does not try to nest.
    terminal.shell = lib.mkForce [ "zellij" ];
    terminal.privShell = lib.mkForce [
      "zellij"
      "--layout"
      "private"
    ];

    home-manager.users.${username} =
      { lib, ... }:
      {
        home.packages = [ pkgs.zellij ];

        xdg.configFile = {
          "zellij/config.kdl".source = configKdl;
          "zellij/layouts/default.kdl".source = ./layouts/default.kdl;
          "zellij/layouts/private.kdl".source = privateLayout;
          "matugen/templates/zellij.kdl".source = themeTpl;
          "matugen/dms/configs/zellij.toml".source = matugenCfg;
        };

        home.activation.zellijFallbackTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          SOURCE=${fallbackTheme}
          TARGET=${user.homepath}/.config/zellij/themes/dms.kdl
          $DRY_RUN_CMD mkdir -p "$(dirname "$TARGET")"
          if [ ! -f "$TARGET" ]; then
            $DRY_RUN_CMD install -m 0644 "$SOURCE" "$TARGET"
          fi
        '';
      };
  };
}
