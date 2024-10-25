{ pkgs }:
pkgs.rustPlatform.buildRustPackage {
  pname = "wakatime-ls";
  version = "v0.1.4";

  doCheck = false;
  src = pkgs.fetchFromGitHub {
    owner = "wakatime";
    repo = "zed-wakatime";
    rev = "v0.1.4";
    sha256 = "1rdx80g3bkgcx09x6whrmgj3lc0a73da7m63r4wmgamg8naax0lr";
  };

  cargoBuildFlags = "-p wakatime-ls";
  cargoHash = "1jis95l4p930qxi2325ivnf43r738wggpml5rnlp08njpd7w8sld";
  cargoLock = { lockFile = ./Cargo.lock; };

  meta = {
    homepage = "https://github.com/wakatime/zed-wakatime";
    description = "A Wakatime extension for Zed.";
  };
}
