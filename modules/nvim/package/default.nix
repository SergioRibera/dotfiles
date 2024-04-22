{ pkgs
, cfg
, user
, lib
, ...
}:
with lib lib.lists;
let
  # import complete config
  customPlugins = import ./plugins { inherit pkgs user; };
  nvimLsp = import ./lsp { inherit pkgs; };
  initLua = builtins.readFile ./init.lua;
  autocmdLua = builtins.readFile ./autocmd.lua;
  mappingLua = builtins.readFile ./mapping.lua;
  utilsLua = builtins.readFile ./utils.lua;
  tablineLua = builtins.readFile ./tabline.lua;
  completePackages = optional cfg.complete customPlugins.packages;
  completePlugins = optional cfg.complete (cfg.plugins ++ [ nvimLsp ]);
  modPluginsLua = optionalString cfg.complete (builtins.readFile ./plugins/mod.lua);
  miscLua = optionalString cfg.complete (builtins.readFile ./misc.lua);
in
pkgs.nixvim.mkNixvim {
  enable = true;
  enableMan = false;
  defaultEditor = true;

  extraPackages = [ pkgs.ripgrep pkgs.fd ] ++ completePackages;

  extraLuaConfig = autocmdLua
    + utilsLua
    + miscLua
    + modPluginsLua
    + initLua
    + mappingLua
    + tablineLua;

  globals = {
    loaded_s4rch_tabline = 1;
    mapleader = " ";
    instant_username = user.username;
    autoread = true;

    # Identline
    indentLine_enabled = 1;
    indentLine_char_list = [ "▏" "¦" "┆" "┊" ];
    ident_blankline_ident_level = 4;
    indent_blankline_show_current_context = true;
    indent_blankline_use_treesitter = true;
    indent_blankline_context_patterns = [ "class" "function" "method" "void" "keyword" ];

    neovide_cursor_antialiasing = cfg.complete; # Neovide cursor Antialiasing
    neovide_cursor_vfx_mode = optional cfg.complete "ripple";
  };

  plugins = with pkgs.vimPlugins; [
    # completion
    cmp-path
    cmp-buffer
    cmp-cmdline
    (import ./plugins/cmp.nix { inherit user pkgs; })
    # status bar
    (import ./plugins/lualine.nix { inherit user pkgs; })
    # Editor
    nvim-autopairs
    nvim-surround
    indent-blankline-nvim
    # UI
    telescope-file-browser-nvim
    telescope-ui-select-nvim
    popup-nvim
    (import ./plugins/telescope.nix { inherit user pkgs; })
  ]
  ++ completePlugins;
}
