{ pkgs ? import <nixpkgs> { }
, lib
, pkg-config
, rustPlatform
, makeWrapper
,
}:
let
  src = pkgs.fetchFromGitHub {
    owner = "H3rmt";
    repo = "hyprswitch";
    rev = "7a9f99612b45af0b0a0588b00949d1fe39aa41aa";
    sha256 = "1g965drx6r194mrij1gkripqxvbmbhkifzl6f3h6vbg1ixn28l63";
  };
  # meta = (builtins.fromTOML (builtins.readFile "${src}/Cargo.toml")).package;
in
rustPlatform.buildRustPackage
{
  name = "hyprswitch";
  version = "1.2.2";
  doCheck = false;
  doInstallCheck = false;
  cargoHash = "sha256-LiH7OqQL7te1GVF3qfYVRQpAhQmsVGtgwhKhZorQp2k=";

  inherit src;

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = with pkgs; [
    glib
    gtk4
    libadwaita
    gtk4-layer-shell
  ];

  postInstall = ''
    wrapProgram $out/bin/hyprswitch
  '';

  meta = with lib; {
    description = "A CLI/GUI that allows switching between windows in Hyprland";
    homepage = "https://github.com/H3rmt/hyprswitch";
    license = licenses.mit;
  };
}
