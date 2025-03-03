{ pkgs }:
pkgs.rustPlatform.buildRustPackage {
  pname = "wakatime-ls";
  version = "v0.1.7";

  doCheck = false;
  src = pkgs.fetchFromGitHub {
    owner = "wakatime";
    repo = "zed-wakatime";
    rev = "v0.1.7";
    sha256 = "1rdx80g3bkgcx09x6whrmgj3lc0a73da7m63r4wmgamg8naax0lr";
  };

  cargoBuildFlags = "-p wakatime-ls";
  cargoHash = "sha256-IBbbe0rRP1Rj8xKuF2tJuFI9kTt3z1MO0hfTsHiGBYU=";
  cargoLock = { lockFile = ./Cargo.lock; };

  meta = {
    homepage = "https://github.com/wakatime/zed-wakatime";
    description = "A Wakatime extension for Zed.";
  };
}
