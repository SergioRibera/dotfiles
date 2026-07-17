{
  lib,
  rustPlatform,
  clangStdenv,
  fetchFromGitHub,
  linkFarm,
  fetchgit,
  runCommand,
  gn,
  libiconv,
  ninja,
  nix-update-script,
  makeWrapper,
  pkg-config,
  python3,
  removeReferencesTo,
  cctools,
  fontconfig,
  stdenv,
  libglvnd,
  libx11,
  libxcb,
  libxcursor,
  libxext,
  libxrandr,
  libxi,
  libxkbcommon,
  enableWayland ? stdenv.hostPlatform.isLinux,
  versionCheckHook,
  wayland,
}:

rustPlatform.buildRustPackage.override { stdenv = clangStdenv; } (finalAttrs: {
  pname = "simplemoji";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "SergioRibera";
    repo = "simplemoji";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3u2Xh6e/SJzlfrTme0TpIhJuWlEhmArXYSverJbA95A=";
  };

  cargoHash = "sha256-G5JYXmO95bQ9yEtQDRDhjnIFQTiatz6EYD5SZKXj0bk=";

  env = {
    SKIA_SOURCE_DIR =
      let
        repo = fetchFromGitHub {
          owner = "rust-skia";
          repo = "skia";
          # see rust-skia:skia-bindings/Cargo.toml#package.metadata skia
          tag = "m150-0.98.1";
          hash = "sha256-h/TFrGlqDur7bvIc9CBqDBwSJOQBk0N52/jwle3ay7c=";
        };
        # The externals for skia are taken from skia/DEPS
        externals = linkFarm "skia-externals" (
          lib.mapAttrsToList (name: value: {
            inherit name;
            path = fetchgit value;
          }) (lib.importJSON ./skia-externals.json)
        );
      in
      runCommand "source" { } ''
        cp -R ${repo} $out
        chmod -R +w $out
        ln -s ${externals} $out/third_party/externals
      '';

    SKIA_GN_COMMAND = "${gn}/bin/gn";
    SKIA_NINJA_COMMAND = "${ninja}/bin/ninja";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    python3 # skia
    removeReferencesTo
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
    cctools.libtool
  ];

  buildInputs = [
    libxcb
    libxkbcommon
    fontconfig
    libx11
    rustPlatform.bindgenHook
  ];

  postFixup =
    let
      libPath = lib.makeLibraryPath (
        [
          libglvnd
          libxkbcommon
          libxcursor
          libxext
          libxrandr
          libxi
        ]
        ++ lib.optionals enableWayland [ wayland ]
      );
    in
    ''
      # library skia embeds the path to its sources
      remove-references-to -t "$SKIA_SOURCE_DIR" \
        $out/bin/simplemoji

      wrapProgram $out/bin/simplemoji \
        --prefix LD_LIBRARY_PATH : ${libPath}
    '';

  disallowedReferences = [ finalAttrs.env.SKIA_SOURCE_DIR ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast Application for look your amazing emojis written in Rust";
    mainProgram = "simplemoji";
    homepage = "https://github.com/SergioRibera/simplemoji";
    changelog = "https://github.com/SergioRibera/simplemoji/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sergioribera
    ];
  };
})
