{ pkgs, lib, inputs, ctx }:
let
  cfg = import ./module.nix { inherit (ctx) shell user gui pkgs lib; };
in
{
  home.packages = [ cfg.pkg ];
  xdg.configFile = {
    "zellij/config.kdl".source = cfg.configKdl;
    "zellij/layouts/default.kdl".source = "${cfg.layoutsDir}/default.kdl";
    "zellij/layouts/private.kdl".source = cfg.privateLayout;
    "matugen/templates/zellij.kdl".source = cfg.themeTpl;
    "matugen/dms/configs/zellij.toml".source = cfg.matugenCfg;
  };
  home.activation.zellijFallbackTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    SOURCE=${cfg.fallbackTheme}
    TARGET=${cfg.homepath}/.config/zellij/themes/dms.kdl
    $DRY_RUN_CMD mkdir -p "$(dirname "$TARGET")"
    if [ ! -f "$TARGET" ]; then
      $DRY_RUN_CMD install -m 0644 "$SOURCE" "$TARGET"
    fi
  '';
}
