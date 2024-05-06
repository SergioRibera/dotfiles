{ inputs, config, pkgs }: with pkgs; (dwl.overrideAttrs (oldAttrs: {
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

  patches = [
    # regexrules patch - 2024-04-11
    (fetchpatch {
      url = "https://codeberg.org/dwl/dwl-patches/raw/commit/2a6560c167e5c9afc5598ac5431d23d90de8846c/regexrules/regexrules.patch";
      sha256 = "04wkwwqcwn522sd9652k673zzrlmd2zf7libqrcj2gm38p3dwj5d";
    })
    # numlock at startup - 2023-11-25
    (fetchpatch {
      url = "https://codeberg.org/dwl/dwl-patches/raw/branch/main/numlock-capslock/numlock-capslock.patch";
      sha256 = "0h0h3xyrjh93ymnclisi8r9pnh4cnp4979paxk4k8cpiymzrjh6a";
    })
    # naturalscrolltrackpad - 2024-01-06
    (fetchpatch {
      url = "https://codeberg.org/dwl/dwl-patches/raw/branch/main/naturalscrolltrackpad/naturalscrolltrackpad.patch";
      sha256 = "14c02bkp78w7fi3r6cql4b0b9p0jdr6jq4g1zfycjvl025azgnds";
    })
    # monitorconfig - 2024-02-15
    (fetchpatch {
      url = "https://codeberg.org/dwl/dwl-patches/raw/branch/main/monfig/monfig.patch";
      sha256 = "1ik6fl06wdi1s2b765sx8znklfdsi420s4djw1nf9kzm4lhl35c8";
    })
    # autostart - 2024-03-31
    (fetchpatch {
      url = "https://codeberg.org/dwl/dwl-patches/raw/branch/main/autostart/autostart.patch";
      sha256 = "086wszszbjnszfcs91zb7jy8ns020nf21s4l39j141drqww07254";
    })
    # gestures - 2024-04-11
    (fetchpatch {
      url = "https://codeberg.org/dwl/dwl-patches/raw/commit/be3735bc6a5c64ff76c200a8679453bd179be456/gestures/gestures.patch";
      sha256 = "11k95ixl9ic4bqsvhypb0y5amsgc59kphy6a8zpnl7mky71nxv5r";
    })
    # cursortheme - 2024-04-11
    (fetchpatch {
      url = "https://codeberg.org/dwl/dwl-patches/raw/commit/b828e21717fa584affeb3245359c3ab615759fa4/cursortheme/cursortheme.patch";
      sha256 = "0648c50rsanwzpsggzjpwrjfmriv3q1pll37n8gd3fjvjrblnp9j";
    })
    # fragmfact - 2024-02-16
    # Change mfact by dragging the mouse.
    (fetchpatch {
      url = "https://codeberg.org/dwl/dwl-patches/raw/branch/main/dragmfact/dragmfact.patch";
      sha256 = "0gcqznr9668cd84nq3mgisd5awj6q67wzwxbsr8l7crfcmni8r0s";
    })
    # scenefx - 2024-04-11
    # Enable effects like corners, shadows, blur to wayland compositors.
    (fetchpatch {
      url = "https://codeberg.org/dwl/dwl-patches/raw/commit/6e3a57ffd16dafa31900b7e89e51672bd7bcc1e8/scenefx/scenefx.patch";
      sha256 = "06pars5fd0wshqll9ni8h1a59cj9mwjy9jvfi938rw81bfaw1pqb";
    })
    # shiftview - 2024-01-27
    # Add keybindings to cycle through tags with visible clients.
    (fetchpatch {
      url = "https://codeberg.org/dwl/dwl-patches/raw/branch/main/shiftview/shiftview.patch";
      sha256 = "0mdrh5dmdk49x873xkvpac8qvl11pk9rv7aw3fr2is1fdks9149f";
    })
  ];

  # version controlled config file
  conf= builtins.readFile (pkgs.substituteAll {
    src = ./dwl.def.h;
    inherit (config.gui.theme) round;
    inherit (config.gui.cursor) name size;
    wallpapers = inputs.wallpapers;
  });
}))
