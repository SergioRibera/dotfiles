{ scenefx, pkgs }: let
  libx = import ../../lib {
    inherit pkgs;
    inherit (pkgs) lib;
  };
  # builtins.readFile()
  myConf = libx.replaceVal ./dwl.def.h {
    # round = config.gui.theme.round;
    # cursortheme = config.gui.cursor.name;
    # cursorsize = config.gui.cursor.size;
    # wallpapers = inputs.wallpapers;
    round = 8;
    cursortheme = "Bibata";
    cursorsize = 24;
    wallpapers = "~/Pictures/";
  };
in with pkgs; (dwl.overrideAttrs (oldAttrs: rec {
  version = "ab4cb6e28365cf8754d6d3bdd293c05abfc27e26";
  src = builtins.fetchGit {
    url = "https://codeberg.org/dwl/dwl";
    rev = version;
  };

  buildInputs = oldAttrs.buildInputs ++ [
    # inputs.self.packages.${pkgs.system}.scenefx
    scenefx
    libGL

    # dwl buildInputs
    libinput
    xorg.libxcb
    libxkbcommon
    pixman
    wayland
    wayland-protocols
    wlroots
    xorg.libX11
    xorg.xcbutilwm
    xwayland
  ];

  # version controlled config file
  # conf= builtins.readFile ();
  postPatch = "cp ${myConf} config.def.h";
  # postPatch = "cp ${./dwl.def.h} config.def.h";

  patches = [
    # regexrules patch - 2024-04-11
    # https://codeberg.org/wochap/dwl
    # ./patches/v0.5-regexrules.patch

    # naturalscrolltrackpad - 2024-01-06
    # (fetchpatch {
    #   excludes = [ "config.def.h" ];
    #   url = "https://codeberg.org/dwl/dwl-patches/raw/branch/main/naturalscrolltrackpad/naturalscrolltrackpad.patch";
    #   sha256 = "14c02bkp78w7fi3r6cql4b0b9p0jdr6jq4g1zfycjvl025azgnds";
    # })

    # gestures - 2024-04-11
    # https://codeberg.org/wochap/dwl
    # ./patches/v0.5-gestures.patch

    # cursortheme - 2024-04-11
    # https://codeberg.org/wochap/dwl
    (fetchpatch {
      excludes = [ "config.def.h" ];
      url = "https://codeberg.org/wochap/dwl/raw/branch/v0.6-b/cursortheme/cursortheme.patch";
      sha256 = "sha256-E544m6ca2lYbjYxyThr3GQEhDqh2SDjryLV/g4X8Rt4=";
    })

    # fragmfact - 2024-02-16
    #

    # shiftview - 2024-01-27
    # Add keybindings to cycle through tags with visible clients.
    # https://codeberg.org/guidocella/dwl
    # ./patches/shiftview.patch

    # monitorconfig - 2025-07-01
    (fetchpatch {
      excludes = [ "config.def.h" ];
      url = "https://codeberg.org/dwl/dwl-patches/raw/commit/770aad7716ecd08774d99e9905f2ebb0c1f719fa/patches/monitorconfig/monitorconfig.patch";
      sha256 = "sha256-MZNPHAHU/tDwUUUuY3j9AtCpQ+52fwaC9+vz8PlSHik=";
    })
    # numlock at startup - 2025-07-19
    (fetchpatch {
      excludes = [ "config.def.h" ];
      url = "https://codeberg.org/dwl/dwl-patches/raw/commit/770aad7716ecd08774d99e9905f2ebb0c1f719fa/patches/numlock-capslock/numlock-capslock.patch";
      sha256 = "sha256-tHFwr6M1JOWD4cJcICMKkwedrKXEt81MgKOLN3h3AtM=";
    })
    # autostart - 2024-03-31
    # (fetchpatch {
    #   url = "https://codeberg.org/dwl/dwl-patches/src/commit/3ebb0248f3803f71f5da45e88eb51580b9b06cea/patches/autostart/autostart.patch";
    #   sha256 = "0x0bppkpc3w1am3k6yikbkdnisd80mdmh2018hlm40qk2zpqlpy3";
    # })
    # gestures - 2024-04-11
    # (fetchpatch {
    #   excludes = [ "config.def.h" ];
    #   url = "https://codeberg.org/dwl/dwl-patches/raw/commit/be3735bc6a5c64ff76c200a8679453bd179be456/gestures/gestures.patch";
    #   sha256 = "11k95ixl9ic4bqsvhypb0y5amsgc59kphy6a8zpnl7mky71nxv5r";
    # })

    # scenefx - 2025-03-09
    # Enable effects like corners, shadows, blur to wayland compositors.
    (fetchpatch {
      excludes = [ "config.def.h" ];
      url = "https://codeberg.org/wochap/dwl/raw/commit/f9f18f2dbe4e39ae91f1cc454673cfd38525b5ea/scenefx.patch";
      sha256 = "sha256-ApA1Erjv2xrXjbiIgXgSC9i/HrlxzuyBHZjbKTSZ1cQ=";
    })
    # fragmfact - 2024-02-16
    # Change mfact by dragging the mouse.
    # (fetchpatch {
    #   url = "https://codeberg.org/dwl/dwl-patches/raw/commit/3ebb0248f3803f71f5da45e88eb51580b9b06cea/patches/dragmfact/dragmfact.patch";
    #   sha256 = "0gcqznr9668cd84nq3mgisd5awj6q67wzwxbsr8l7crfcmni8r0s";
    # })
    # shiftview - 2024-01-27
    # Add keybindings to cycle through tags with visible clients.
    # (fetchpatch {
    #   url = "https://codeberg.org/dwl/dwl-patches/raw/commit/3ebb0248f3803f71f5da45e88eb51580b9b06cea/patches/shiftview/shiftview.patch";
    #   sha256 = "0mdrh5dmdk49x873xkvpac8qvl11pk9rv7aw3fr2is1fdks9149f";
    # })
  ];
}))
