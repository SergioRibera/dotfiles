final: prev: rec {
  mac-style = prev.callPackage ./plymouth-macstyle { };
  hyprswitch = prev.callPackage ./hyprswitch { };
  scenefx = prev.callPackage ./scenefx { };

  # Nvim Extra Plugins
  nvim-surround = prev.callPackage ./nvim/surround.nix { };
  nvim-lsp-progress = prev.callPackage ./nvim/lsp-progress.nix { };
  nvim-wakatime = prev.callPackage ./nvim/wakatime.nix { };

  nvim-cmp-dotenv = prev.callPackage ./nvim/cmp-dotenv.nix { };
  nvim-codeshot = prev.callPackage ./nvim/codeshot.nix { };

  # LSP
  discord-presence = prev.callPackage ./lsp/discord { };
  wakatime-ls = prev.callPackage ./lsp/wakatime { };

  # Utils
  simple-commits = prev.callPackage ./simple-commits { };

  # Cosmic
  libcosmicAppHook = prev.callPackage ./cosmic/libcosmic-app-hook { };
  cosmic-files = prev.callPackage ./cosmic/files { inherit libcosmicAppHook; };
  xdg-desktop-portal-cosmic = prev.callPackage ./cosmic/xdg-portal { inherit libcosmicAppHook; };

  firefoxAddons = prev.callPackage ./firefox-addons { };
}
