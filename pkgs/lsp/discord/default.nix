{ pkgs }:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "discord-presence";
  version = "0.5.0";

  doCheck = false;
  src = pkgs.fetchFromGitHub {
    owner = "xhyrom";
    repo = "zed-discord-presence";
    rev = "v${version}";
    hash = "sha256-PMtTwVVH0JGeTp523Oy7BP94fviRrel0FxED2FgZ/D4=";
  };

  cargoBuildFlags = "-p discord-presence-lsp";
  cargoLock.lockFile = ./Cargo.lock;

  meta = {
    homepage = "https://github.com/xhyrom/zed-discord-presence";
    description = "Extension for zed that adds support for discord rich presence using lsp";
  };
}
