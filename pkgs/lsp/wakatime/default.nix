{ pkgs }:
pkgs.rustPlatform.buildRustPackage {
  pname = "wakatime-ls";
  version = "v0.1.7";

  doCheck = false;
  src = pkgs.fetchFromGitHub {
    owner = "wakatime";
    repo = "zed-wakatime";
    rev = "v0.1.9";
    sha256 = "sha256-GSIu5yD9V4KAMvSR1Ke9N20gPZDL7Rls9XNonddkUDY=";
  };

  cargoBuildFlags = "-p wakatime-ls";
  cargoHash = "sha256-WBk8zSRUqqYKiYK+c4CdkoLf1RcbwNIMYhUFRWerRPY=";
  cargoLock = { lockFile = ./Cargo.lock; };

  meta = {
    homepage = "https://github.com/wakatime/zed-wakatime";
    description = "A Wakatime extension for Zed.";
  };
}
