{ pkgs }:
pkgs.rustPlatform.buildRustPackage {
  pname = "wakatime-ls";
  version = "v0.1.6";

  doCheck = false;
  src = pkgs.fetchFromGitHub {
    owner = "wakatime";
    repo = "zed-wakatime";
    rev = "v0.1.6";
    sha256 = "1rdx80g3bkgcx09x6whrmgj3lc0a73da7m63r4wmgamg8naax0lr";
  };

  cargoBuildFlags = "-p wakatime-ls";
  cargoHash = "sha256-UKSk1Jm5QhxEu3lJTWMN8JMIvy8kPX/DPOTybqeJG5M=";
  # cargoLock = { lockFile = ./Cargo.lock; };

  meta = {
    homepage = "https://github.com/wakatime/zed-wakatime";
    description = "A Wakatime extension for Zed.";
  };
}
