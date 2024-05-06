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
      sha256 = "";
    })
    # numlock at startup - 2023-11-25
    (fetchpatch {
      url = "https://codeberg.org/dwl/dwl-patches/raw/branch/main/numlock-capslock/numlock-capslock.patch";
      sha256 = "";
    })
    # naturalscrolltrackpad - 2024-01-06
    (fetchpatch {
      url = "https://codeberg.org/dwl/dwl-patches/raw/branch/main/naturalscrolltrackpad/naturalscrolltrackpad.patch";
      sha256 = "";
    })
    # monitorconfig - 2024-02-15
    (fetchpatch {
      url = "https://codeberg.org/dwl/dwl-patches/raw/branch/main/monfig/monfig.patch";
      sha256 = "";
    })
    # autostart - 2024-03-31
    (fetchpatch {
      url = "https://codeberg.org/dwl/dwl-patches/raw/branch/main/autostart/autostart.patch";
      sha256 = "";
    })
    # gestures - 2024-04-11
    (fetchpatch {
      url = "https://codeberg.org/dwl/dwl-patches/raw/commit/be3735bc6a5c64ff76c200a8679453bd179be456/gestures/gestures.patch";
      sha256 = "";
    })
    # cursortheme - 2024-04-11
    (fetchpatch {
      url = "https://codeberg.org/dwl/dwl-patches/raw/commit/b828e21717fa584affeb3245359c3ab615759fa4/cursortheme/cursortheme.patch";
      sha256 = "";
    })
    # fragmfact - 2024-02-16
    # Change mfact by dragging the mouse.
    (fetchpatch {
      url = "https://codeberg.org/dwl/dwl-patches/raw/branch/main/dragmfact/dragmfact.patch";
      sha256 = "";
    })
    # scenefx - 2024-04-11
    # Enable effects like corners, shadows, blur to wayland compositors.
    (fetchpatch {
      url = "https://codeberg.org/dwl/dwl-patches/raw/commit/6e3a57ffd16dafa31900b7e89e51672bd7bcc1e8/scenefx/scenefx.patch";
      sha256 = "";
    })
    # shiftview - 2024-01-27
    # Add keybindings to cycle through tags with visible clients.
    (fetchpatch {
      url = "https://codeberg.org/dwl/dwl-patches/raw/branch/main/shiftview/shiftview.patch";
      sha256 = "";
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
