{ pkgs, lib, stdenvNoCC, themeConfig ? null }: let
  iniFormat = pkgs.formats.ini { };
  configFile = iniFormat.generate "" { General = ; };
  basePath = "$out/share/sddm/themes/sddm-astronaut-theme";
in stdenvNoCC.mkDerivation {
  pname = "sddm-astronaut";
  version = "1.0";
  src = ./.;

  dontWrapQtApps = true;
  propagatedBuildInputs = with pkgs.kdePackages; [ qt5compat qtsvg ];

  installPhase = ''
    mkdir -p ${basePath}
    cp -r $src/* ${basePath}
  '' + lib.optionalString (themeConfig != null) ''
    ln -sf ${configFile} ${basePath}/theme.conf.user
  '';
}
