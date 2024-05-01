{ crane
, cranix
, fenix
,
}: { config
   , lib
   , pkgs
   , ...
   }:
with lib; let
  app = import ./. {
    inherit crane cranix fenix pkgs lib;
    system = pkgs.system;
  };
  cfgApp = config.programs.app;
  # Temp config
  appPackage = lists.optional cfgApp.enable app.packages.default;
in
{
  options.programs = {
    app = {
      enable = mkEnableOption "enable app";
    };
  };

  config = mkIf cfgZoomer.enable {
    home.packages = appPackage;
  };
}
