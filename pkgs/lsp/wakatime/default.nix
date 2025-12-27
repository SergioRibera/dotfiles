{ pkgs }:
pkgs.rustPlatform.buildRustPackage {
  pname = "wakatime-ls";
  version = "v0.1.9";

  doCheck = false;
  src = pkgs.fetchFromGitHub {
    owner = "wakatime";
    repo = "zed-wakatime";
    rev = "v0.1.9";
    sha256 = "0djhckbrss3kymn1kvfbj0yj0v9ppnkx94gl6a084mzx43kjw8hr";
  };

  cargoBuildFlags = "-p wakatime-ls";
  cargoHash = "sha256-WBk8zSRUqqYKiYK+c4CdkoLf1RcbwNIMYhUFRWerRPY=";
  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  meta = {
    homepage = "https://github.com/wakatime/zed-wakatime";
    description = "A Wakatime extension for Zed.";
  };
}
