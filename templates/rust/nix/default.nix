let
  inherit (builtins)
    currentSystem
    fromJSON
    readFile
    ;
  getFlake =
    name: with (fromJSON (readFile ../flake.lock)).nodes.${name}.locked; {
      inherit rev;
      outPath = fetchTarball {
        url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
        sha256 = narHash;
      };
    };
in
{
  system ? currentSystem,
  pkgs ? import (getFlake "nixpkgs") { localSystem = { inherit system; }; },
  lib ? pkgs.lib,
  crane,
  cranix,
  fenix,
  stdenv ? pkgs.stdenv,
  ...
}:
let
  # fenix: rustup replacement for reproducible builds
  # toolchain = fenix.${system}.fromToolchainFile { dir = ./..; };
  toolchain = fenix.${system}.fromToolchainFile {
    file = ./../rust-toolchain.toml;
    sha256 = "sha256-e4mlaJehWBymYxJGgnbuCObVlqMlQSilZ8FljG9zPHY=";
  };
  # crane: cargo and artifacts manager
  craneLib = crane.${system}.overrideToolchain toolchain;
  # cranix: extends crane building system with workspace bin building and Mold + Cranelift integrations
  cranixLib = craneLib.overrideScope' (cranix.${system}.craneOverride);

  # buildInputs for zimplemoji
  buildInputs = with pkgs; [
    stdenv.cc.cc.lib
    # fontconfig.dev
    libxkbcommon
    libxkbcommon.dev
    wayland
    wayland.dev
    # expat
    # freetype
    # freetype.dev
    # libGL
    pkg-config
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
  ];

  # Base args, need for build all crate artifacts and caching this for late builds
  deps = {
    nativeBuildInputs = [
      pkgs.pkg-config
      pkgs.autoPatchelfHook
    ]
    ++ lib.optionals stdenv.buildPlatform.isDarwin [
      pkgs.libiconv
    ]
    ++ lib.optionals stdenv.buildPlatform.isLinux [
      pkgs.libxkbcommon.dev
    ];
    runtimeDependencies =
      with pkgs;
      lib.optionals stdenv.isLinux [
        wayland
        libxkbcommon
      ];
    inherit buildInputs;
  };

  # Lambda for build packages with cached artifacts
  commonArgs =
    { }:
    deps
    // {
      src = lib.cleanSourceWith {
        src = craneLib.path ./..;
        filter = craneLib.filterCargoSources;
      };
      doCheck = false;
      CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER = "${stdenv.cc.targetPrefix}cc";
      CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_RUNNER = "qemu-aarch64";
      HOST_CC = "${stdenv.cc.nativePrefix}cc";
      # workspaceTargetName = targetName;
    };

  # Build packages and `nix run` apps
  appPkg = cranixLib.buildCranixBundle (commonArgs { });
in
{
  # `nix run`
  apps = rec {
    app = appPkg.app;
    default = app;
  };
  # `nix build`
  packages = rec {
    app = appPkg.pkg;
    default = app;
  };
  # `nix develop`
  devShells.default = cranixLib.devShell {
    packages =
      with pkgs;
      [
        toolchain
        pkg-config
        cargo-dist
        cargo-release
        wayland
        libxkbcommon
      ]
      ++ buildInputs;
    # PKG_CONFIG_PATH = "${pkgs.fontconfig.dev}/lib/pkgconfig";
  };
}
