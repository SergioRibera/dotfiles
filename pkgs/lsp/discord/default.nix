{ pkgs }:
pkgs.rustPlatform.buildRustPackage {
  pname = "discord-presence";
  version = "v0.8.3";

  doCheck = false;
  src = pkgs.fetchFromGitHub {
    owner = "xhyrom";
    repo = "zed-discord-presence";
    rev = "v0.8.3";
    sha256 = "07mycfnbmk1igbs7bsmxf8l8dky20h6yrj0akb3dhrh9krdvqbfk";
  };

  cargoBuildFlags = "-p discord-presence-lsp";
  cargoHash = "sha256-haT7fLRWlqBM/NybWn/VaMoMuU0M9dUoesioPX/sOrw=";
  cargoLock = { lockFile = ./Cargo.lock; };

  meta = {
    homepage = "https://github.com/xhyrom/zed-discord-presence";
    description = "Extension for zed that adds support for discord rich presence using lsp";
  };
}
