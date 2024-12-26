{ pkgs }:
pkgs.rustPlatform.buildRustPackage {
  pname = "discord-presence";
  version = "v0.6.0";

  doCheck = false;
  src = pkgs.fetchFromGitHub {
    owner = "xhyrom";
    repo = "zed-discord-presence";
    rev = "v0.6.0";
    sha256 = "0r7gpihv5bh4av8rn9rjyphkvqija67w50gng3baxq27mzryygvz";
  };

  cargoBuildFlags = "-p discord-presence-lsp";
  cargoHash = "sha256-wn+G8orTRZlA3sW8yw04GyUvoSgWm6cOrAJIt/uyBkY=";
  # cargoLock = { lockFile = ./Cargo.lock; };

  meta = {
    homepage = "https://github.com/xhyrom/zed-discord-presence";
    description = "Extension for zed that adds support for discord rich presence using lsp";
  };
}
