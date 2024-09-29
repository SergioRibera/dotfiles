{ pkgs }:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "wakatime-ls";
  version = "0.1.3";

  doCheck = false;
  src = pkgs.fetchFromGitHub {
    owner = "wakatime";
    repo = "zed-wakatime";
    rev = "v${version}";
    hash = "sha256-Z62iMY5hTk/l9ZNBvGBH01Cb65bUUFwRDouruCMKDCE=";
  };

  cargoBuildFlags = "-p wakatime-ls";
  cargoLock.lockFile = ./Cargo.lock;

  meta = {
    homepage = "https://github.com/wakatime/zed-wakatime";
    description = "A Wakatime extension for Zed.";
  };
}
