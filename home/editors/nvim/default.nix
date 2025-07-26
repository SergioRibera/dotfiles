{ inputs
, pkgs
, cfg
, user
, gui
, shell
, ...
}:
with pkgs.lib;
let
  tablineLua = builtins.readFile ./tabline.nix;
  cmpUtilsLua = optionalString cfg.complete (builtins.readFile ./plugins/cmp.lua);
in
{
  viAlias = true;
  vimAlias = true;
  enableMan = false;
  vimdiffAlias = true;
  defaultEditor = true;

  # Packages
  extraPackages = [ pkgs.fd ]
    ++ lists.optionals (gui.enable && cfg.neovide) [ pkgs.neovide ];
    # ++ lists.optionals cfg.complete [ pkgs.gdb ];

  dependencies = { ripgrep.enable = true; };

  # Raw lua
  extraConfigLuaPre = cmpUtilsLua + tablineLua;

  # Neovim options
  opts = import ./opts.nix { lib = pkgs.lib; guiEnable = gui.enable; };
  highlightOverride = import ./colorscheme.nix { inherit (gui.theme) colors; };

  # Keymaps
  keymaps = import ./mapping.nix {
    lib = pkgs.lib;
    shell = shell.name;
    complete = cfg.complete;
  };

  # Groups
  autoGroups = {
    lualine_augroup.clear = true;
  };

  # Neovim Commands
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
  ] ++ pkgs.lib.lists.optionals cfg.complete [
    # Refresh LSP progress on lualine
    {
      event = "User";
      group = "lualine_augroup";
      pattern = [ "LspProgressStatusUpdated" ];
      callback = { __raw = "require('lualine').refresh"; };
    }
  ];

  # Global Options
  globals = import ./globals.nix {
    lib = pkgs.lib;
    colors = gui.theme.colors;
    username = user.username;
    complete = cfg.complete;
  };

  # plugins = import ./plugins { inherit inputs pkgs user cfg gui; };
  # lsp = pkgs.lib.mkIf cfg.complete (import ./lsp);
}
