{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation
{
  pname = "mac-style";
  version = "856bf3b7d239f995e4e9dde8458b9823cf0e96e4";

  src = pkgs.fetchFromGitHub {
    owner = "SergioRibera";
    repo = "s4rchiso-plymouth-theme";
    rev = "856bf3b7d239f995e4e9dde8458b9823cf0e96e4";
    sha256 = "1n1lm8n1sry0lz3q1y1m5k0dn73hyq6zzg55rlf7clivkxy7i05m";
  };

  buildInputs = with pkgs; [ git ];

  installPhase = ''
    mkdir -p $out/share/plymouth/themes/mac-style
    cp -r src/mac-style $out/share/plymouth/themes/
    chmod +x $out/share/plymouth/themes/mac-style/mac-style.plymouth
  '';
}