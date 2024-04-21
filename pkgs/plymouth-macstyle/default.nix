{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation
{
  pname = "mac-style";
  version = "0.1.0";

  src = pkgs.fetchFromGitHub {
    owner = "SergioRibera";
    repo = "s4rchiso-plymouth-theme";
    rev = "bc585b7f42af415fe40bece8192d9828039e6e20";
    sha256 = "sha256-yOvZ4F5ERPfnSlI/Scf9UwzvoRwGMqZlrHkBIB3Dm/w=";
  };

  buildInputs = with pkgs; [ git ];

  configPhase = ''
    mkdir -p $out/share/plymouth/themes/mac-style
  '';

  installPhase = ''
    cp -r src/mac-style $out/share/plymouth/themes/
    chmod +x $out/share/plymouth/themes/mac-style/mac-style.plymouth
  '';
}
