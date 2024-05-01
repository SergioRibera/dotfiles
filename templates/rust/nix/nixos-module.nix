{
  crane,
  cranix,
  fenix,
}: {
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  zoomer = import ./. {
    inherit crane cranix fenix pkgs lib;
    system = pkgs.system;
  };
  cfg = config.programs.zoomer;
in {
  options.programs.zoomer = {
    enable = mkEnableOption "tool to zoom screen";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [zoomer.packages.default];
  };
}
