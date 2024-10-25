{ pkgs }:
pkgs.rustPlatform.buildRustPackage {
  pname = "discord-presence";
  version = "v0.5.1";

  doCheck = false;
  src = pkgs.fetchFromGitHub {
    owner = "xhyrom";
    repo = "zed-discord-presence";
    rev = "v0.5.1";
    sha256 = "0r7gpihv5bh4av8rn9rjyphkvqija67w50gng3baxq27mzryygvz";
  };

  cargoBuildFlags = "-p discord-presence-lsp";
  cargoHash = "0igwr4lafv8bnysai3gnnq3nfllgff2dqwmq1rkbmb4vbshrcwza";
  cargoLock = { lockFile = ./Cargo.lock; };

  meta = {
    homepage = "https://github.com/xhyrom/zed-discord-presence";
    description = "Extension for zed that adds support for discord rich presence using lsp";
  };
}
