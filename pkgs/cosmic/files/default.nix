{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  stdenv,
  glib,
  just,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "cosmic-files";
  version = "ee7954e8d6f5cca93f0151aa920c95071ec1cae0";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-files";
    rev = "ee7954e8d6f5cca93f0151aa920c95071ec1cae0";
    sha256 = "07nymr4apld66kb76793vzgx43akgwdh9515vpcfj9wjm6v6cqsi";
  };

  cargoHash = "sha256-K10q+aWj8p5JYMbvO5QP71j0iOvxIBMMNfJXZ2HGrac=";

  nativeBuildInputs = [ libcosmicAppHook just ];
  buildInputs = [ glib ];

  doCheck = false;
  dontUseJustBuild = true;
  dontUseJustCheck = true;
  useFetchCargoVendor = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-files"
    "--set"
    "applet-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-files-applet"
  ];

  env.VERGEN_GIT_SHA = src.rev;

  # TODO: remove next two phases if these packages ever stop requiring mutually exclusive features
  buildPhase = ''
    baseCargoBuildFlags="$cargoBuildFlags"
    cargoBuildFlags="$baseCargoBuildFlags --package cosmic-files"
    runHook cargoBuildHook
    cargoBuildFlags="$baseCargoBuildFlags --package cosmic-files-applet"
    runHook cargoBuildHook
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-files";
    description = "File Manager for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    mainProgram = "cosmic-files";
  };
}
