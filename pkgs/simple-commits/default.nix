{ pkgs }:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "sc";
  version = "v1.0.2";

  doCheck = false;
  src = pkgs.fetchFromGitHub {
    owner = "romancitodev";
    repo = "simple-commits";
    rev = version;
    hash = "sha256-xW5nObtmVtT+qlnjbHIvuvUcyI8AXScd9EC1CE8oSQY=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  meta = {
    homepage = "https://github.com/romancitodev/simple-commits";
    description = "A little CLI written in rust to improve your dirty commits into conventional ones.";
  };
}
