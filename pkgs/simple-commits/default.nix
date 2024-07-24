{ pkgs }:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "sc";
  version = "v0.2.0";

  doCheck = false;
  src = pkgs.fetchFromGitHub {
    owner = "romancitodev";
    repo = "simple-commits";
    rev = version;
    hash = "sha256-x9lExmWH1NAfV7js7h3wC54Dkot+Q/TAZyKNYADENxQ=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  meta = {
    homepage = "https://github.com/romancitodev/simple-commits";
    description = "A little CLI written in rust to improve your dirty commits into conventional ones.";
  };
}
