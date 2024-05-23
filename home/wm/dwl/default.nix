{ inputs, config, pkgs }: let
  # builtins.readFile()
  myConf = pkgs.substituteAll {
    src = ./dwl.def.h;
    round = config.gui.theme.round;
    cursortheme = config.gui.cursor.name;
    cursorsize = config.gui.cursor.size;
    wallpapers = inputs.wallpapers;
  };
in with pkgs; (dwl.overrideAttrs (oldAttrs: rec {
  version = "9825c26cdd5dfed34022b77a8936c5d8f485e134";
  src = builtins.fetchGit {
    url = "https://codeberg.org/dwl/dwl";
    rev = version;
  };

  buildInputs = oldAttrs.buildInputs ++ [
    inputs.self.packages.${pkgs.system}.scenefx
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

  patches = [
    # regexrules patch - 2024-04-11
    # https://codeberg.org/wochap/dwl
    # ./patches/v0.5-regexrules.patch

    # scenefx - 2024-04-11
    # Enable effects like corners, shadows, blur to wayland compositors.
    # https://codeberg.org/wochap/dwl
    # ./patches/v0.5-scenefx.patch

    # naturalscrolltrackpad - 2024-01-06
    # (fetchpatch {
    #   excludes = [ "config.def.h" ];
    #   url = "https://codeberg.org/dwl/dwl-patches/raw/branch/main/naturalscrolltrackpad/naturalscrolltrackpad.patch";
    #   sha256 = "14c02bkp78w7fi3r6cql4b0b9p0jdr6jq4g1zfycjvl025azgnds";
    # })

    # monitorconfig - 2024-05-03
    # https://codeberg.org/Palanix/dwl
    # ./patches/monfig.patch

    # numlock at startup - 2023-11-25
    # https://codeberg.org/sevz/dwl
    # ./patches/numlock-capslock.patch

    # autostart - 2024-04-01
    # https://codeberg.org/sevz/dwl
    ./patches/autostart.patch

    # gestures - 2024-04-11
    # https://codeberg.org/wochap/dwl
    # ./patches/v0.5-gestures.patch

    # cursortheme - 2024-04-11
    # https://codeberg.org/wochap/dwl
    # ./patches/v0.5-cursortheme.patch

    # fragmfact - 2024-02-16
    #

    # shiftview - 2024-01-27
    # Add keybindings to cycle through tags with visible clients.
    # https://codeberg.org/guidocella/dwl
    # ./patches/shiftview.patch

    # monitorconfig - 2024-02-15
    (fetchpatch {
      url = "https://codeberg.org/dwl/dwl-patches/raw/commit/3ebb0248f3803f71f5da45e88eb51580b9b06cea/patches/monfig/monfig.patch";
      sha256 = "1ik6fl06wdi1s2b765sx8znklfdsi420s4djw1nf9kzm4lhl35c8";
    })
    # numlock at startup - 2023-11-25
    (fetchpatch {
      url = "https://codeberg.org/dwl/dwl-patches/raw/commit/3ebb0248f3803f71f5da45e88eb51580b9b06cea/patches/numlock-capslock/numlock-capslock.patch";
      sha256 = "0h0h3xyrjh93ymnclisi8r9pnh4cnp4979paxk4k8cpiymzrjh6a";
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
    # cursortheme - 2024-04-11
    (fetchpatch {
      url = "https://codeberg.org/dwl/dwl-patches/raw/commit/b828e21717fa584affeb3245359c3ab615759fa4/cursortheme/cursortheme.patch";
      sha256 = "0648c50rsanwzpsggzjpwrjfmriv3q1pll37n8gd3fjvjrblnp9j";
    })
    # scenefx - 2024-04-11
    # Enable effects like corners, shadows, blur to wayland compositors.
    # (fetchpatch {
    #   url = "https://codeberg.org/dwl/dwl-patches/raw/commit/3ebb0248f3803f71f5da45e88eb51580b9b06cea/patches/scenefx/scenefx.patch";
    #   sha256 = "06pars5fd0wshqll9ni8h1a59cj9mwjy9jvfi938rw81bfaw1pqb";
    # })
    # fragmfact - 2024-02-16
    # Change mfact by dragging the mouse.
    (fetchpatch {
      url = "https://codeberg.org/dwl/dwl-patches/raw/commit/3ebb0248f3803f71f5da45e88eb51580b9b06cea/patches/dragmfact/dragmfact.patch";
      sha256 = "0gcqznr9668cd84nq3mgisd5awj6q67wzwxbsr8l7crfcmni8r0s";
    })
    # shiftview - 2024-01-27
    # Add keybindings to cycle through tags with visible clients.
    (fetchpatch {
      url = "https://codeberg.org/dwl/dwl-patches/raw/commit/3ebb0248f3803f71f5da45e88eb51580b9b06cea/patches/shiftview/shiftview.patch";
      sha256 = "0mdrh5dmdk49x873xkvpac8qvl11pk9rv7aw3fr2is1fdks9149f";
    })
  ];
}))
