{ lib, stdenv, fetchFromGitHub, pkgs }:

stdenv.mkDerivation rec {
  pname = "scenefx";
  version = "0466cac4be1333d0794b01f4726780be23535767";

  src = fetchFromGitHub {
    owner = "wlrfx";
    repo = pname;
    rev = version;
    hash = "sha256-4Z5KDDyjXlEaE+w9pojRebssrHnrXJzAkJ7vLZCLDV8=";
  };

  mesonFlags = [ "-Doptimization=2" ];

  preConfigure = ''
    ls
    mkdir -p "$PWD/subprojects"
    cd "$PWD/subprojects"
    cp -R --no-preserve=mode,ownership ${pkgs.wlroots_0_17.src} wlroots
    chmod +x ./wlroots/backend/drm/gen_pnpids.sh
    cd ..
    ls
  '';

  depsBuildBuild = with pkgs; [ wlroots pkg-config ];

  nativeBuildInputs = with pkgs; [
    pkg-config
    meson
    cmake
    ninja
    scdoc
    glslang
    lcms2
    udev
    seatd
    hwdata
    libinput
    libliftoff
    libdisplay-info
    wayland-scanner

    xwayland
    xorg.xcbutilerrors
    xorg.xcbutilimage
    xorg.xcbutilrenderutil
  ];

  buildInputs = with pkgs; [
    libdrm
    libxkbcommon
    pixman
    libGL # egl
    mesa # gbm
    wayland # wayland-server
    wayland-protocols
    libgbm
    xorg.libxcb
    xorg.xcbutilwm

    vulkan-loader
  ];

  meta = with lib; {
    description =
      "A drop-in replacement for the wlroots scene API that allows wayland compositors to render surfaces with eye-candy effects";
    homepage = "https://github.com/wlrfx/scenefx";
    license = licenses.mit;
    mainProgram = "scenefx";
    platforms = platforms.all;
  };
}
