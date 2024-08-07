{ pkgs }:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "sc";
  version = "79b7cee90d6c8756a5ddf6df5fedaef53730d15d";

  doCheck = false;
  src = pkgs.fetchFromGitHub {
    owner = "romancitodev";
    repo = "simple-commits";
    rev = version;
    hash = "sha256-d7/or+mxk6W7ex81BqVs/BqcfN2pfml6gcj6CpZJQMQ=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  meta = {
    homepage = "https://github.com/romancitodev/simple-commits";
    description = "A little CLI written in rust to improve your dirty commits into conventional ones.";
  };
}
