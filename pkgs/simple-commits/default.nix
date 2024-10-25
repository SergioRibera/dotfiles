{ pkgs }:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "sc";
  version = "f372000c7aa72b96d8697a5d1671c3416309f87c";

  doCheck = false;
  src = pkgs.fetchFromGitHub {
    owner = "romancitodev";
    repo = "simple-commits";
    rev = version;
    sha256 = "1x3f1sbrrcdarfr0nhj6x7h74mq1bv88mazmk2i553hl5r02x6fc";
  };

  cargoHash = "0wv5gp9g1dbhr0vjlmzp6l2fgh50ss4hvfb303h71hi4km729q79";
  cargoLock = { lockFile = ./Cargo.lock; };

  meta = {
    homepage = "https://github.com/romancitodev/simple-commits";
    description = "A little CLI written in rust to improve your dirty commits into conventional ones.";
  };
}
