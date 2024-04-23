{ inputs
, pkgs
, cfg
, user
, gui
, lib
, ...
}:
with lib lib.lists;
let
  # import complete config
  customPlugins = import ../plugins { inherit pkgs user; };
  nvimLsp = import ../lsp { inherit pkgs; };
  mappingLua = builtins.readFile ../mapping.lua;
  utilsLua = builtins.readFile ../utils.lua;
  tablineLua = builtins.readFile ../tabline.lua;
  completePackages = optional cfg.complete customPlugins.packages;
  completePlugins = optional cfg.complete (cfg.plugins ++ [ nvimLsp ]);
  modPluginsLua = optionalString cfg.complete (builtins.readFile ../plugins/mod.lua);
  miscLua = optionalString cfg.complete (builtins.readFile ../misc.lua);
  cmpUtilsLua = optionalString cfg.complete (builtins.readFile ../plugins/cmp.lua);
in
inputs.nixvim.mkNixvim {
  enable = true;
  enableMan = false;
  defaultEditor = true;
  viAlias = true;
  vimAlias = true;

  extraPackages = [ pkgs.ripgrep pkgs.fd ] ++ completePackages;

  extraConfigLuaPre = utilsLua
    + cmpUtilsLua
    + miscLua
    + modPluginsLua
    + mappingLua
    + tablineLua;

  opts = import ../opts.nix { };
  # colorscheme
  highlight = import ../colorscheme.nix { inherit (gui) colors; };

  autoGroups = {
    lualine_augroup.clear = true;
  };

  autoCmd = [
    # generate views to record state of file
    {
      event = [ "BufWritePre" "BufWinLeave" ];
      pattern = [ "?*" ];
      command = "silent! mkview";
    }
    # load last view with state of file
    {
      event = [ "BufWinEnter" ];
      pattern = [ "?*" ];
      command = "silent! loadview";
    }
    # reload file when is external modified
    {
      event = [ "CursorHold" "CursorHoldI" ];
      pattern = [ "*" ];
      command = "checktime";
    }
    # Prevent correct works cmp with telescope
    {
      event = [ "FileType" ];
      pattern = [ "TelescopePrompt" ];
      command = "lua require('cmp').setup.buffer { enabled = false }";
    }
  ] ++ lib.lists.optiona cfg.complete [
    # Refresh LSP progress on lualine
    {
      event = "User";
      group = "lualine_augroup";
      pattern = [ "LspProgressStatusUpdated" ];
      callback = { __raw = "require('lualine').refresh"; };
    }
  ];

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
  } // lib.mkIf (!cfg.complete) {
    # Nvim Terminal
    terminal_color_0 = gui.theme.colors.base00;
    terminal_color_1 = gui.theme.colors.base08;
    terminal_color_2 = gui.theme.colors.base0B;
    terminal_color_3 = gui.theme.colors.base0A;
    terminal_color_4 = gui.theme.colors.base0D;
    terminal_color_5 = gui.theme.colors.base0E;
    terminal_color_6 = gui.theme.colors.base0C;
    terminal_color_7 = gui.theme.colors.base05;
    terminal_color_8 = gui.theme.colors.base03;
    terminal_color_9 = gui.theme.colors.base08;
    terminal_color_10 = gui.theme.colors.base0B;
    terminal_color_11 = gui.theme.colors.base0A;
    terminal_color_12 = gui.theme.colors.base0D;
    terminal_color_13 = gui.theme.colors.base0E;
    terminal_color_14 = gui.theme.colors.base0C;
    terminal_color_15 = gui.theme.colors.base07;
    base16_gui00 = gui.theme.colors.base00;
    base16_gui01 = gui.theme.colors.base01;
    base16_gui02 = gui.theme.colors.base02;
    base16_gui03 = gui.theme.colors.base03;
    base16_gui04 = gui.theme.colors.base04;
    base16_gui05 = gui.theme.colors.base05;
    base16_gui06 = gui.theme.colors.base06;
    base16_gui07 = gui.theme.colors.base07;
    base16_gui08 = gui.theme.colors.base08;
    base16_gui09 = gui.theme.colors.base09;
    base16_gui0A = gui.theme.colors.base0A;
    base16_gui0B = gui.theme.colors.base0B;
    base16_gui0C = gui.theme.colors.base0C;
    base16_gui0D = gui.theme.colors.base0D;
    base16_gui0E = gui.theme.colors.base0E;
    base16_gui0F = gui.theme.colors.base0F;
  };

  plugins = {
    # completion
    cmp = import ../plugins/cmp.nix { inherit cfg; };
    cmp-buffer.enable = true;
    cmp-cmdline.enable = true;
    cmp-path.enable = true;
    # # status bar
    lualine = import ../plugins/lualine.nix { inherit user pkgs; colors = gui.colors; };
    # # Editor
    # nvim-autopairs
    # nvim-surround
    # indent-blankline-nvim
    # # UI
    # telescope-file-browser-nvim
    # telescope-ui-select-nvim
    # popup-nvim
    # (import ../plugins/telescope.nix { inherit user pkgs; })
  } // completePlugins;
}
