final: prev: rec {
  hyprswitch = prev.callPackage ./hyprswitch { };

  dwl = prev.callPackage ./dwl { inherit scenefx; };
  scenefx = prev.callPackage ./scenefx { };

  # Nvim Extra Plugins
  nvim-wakatime = prev.callPackage ./nvim/wakatime.nix { };

  nvim-cmp-dotenv = prev.callPackage ./nvim/cmp-dotenv.nix { };
  nvim-codeshot = prev.callPackage ./nvim/codeshot.nix { };

  # LSP
  discord-presence = prev.callPackage ./lsp/discord { };
  wakatime-ls = prev.callPackage ./lsp/wakatime { };

  # Utils
  simple-commits = prev.callPackage ./simple-commits { };
  simplemoji = prev.callPackage ./simplemoji { };

  firefoxAddons = prev.callPackage ./firefox-addons { };
}
