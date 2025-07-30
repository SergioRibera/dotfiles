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
  tablineLua = builtins.readFile ./tabline.lua;
  miscLua = builtins.readFile ./misc.lua;
  pluginsModLua = optionalString cfg.complete (builtins.readFile ./plugins/mod.lua);
in
{
  viAlias = true;
  vimAlias = true;
  enableMan = false;
  package = pkgs.neovim-unwrapped.overrideAttrs (attrs: prev: {
     postBuild = "rm -rf $out/share/applications";
  });

  # Packages
  extraPackages = with pkgs; [ fd ]
    ++ lists.optionals (gui.enable && cfg.neovide) [ nerd-fonts.caskaydia-mono nerd-fonts.fira-code neovide ]
    ++ lists.optionals cfg.complete [ gdb ];

  dependencies = { ripgrep.enable = true; };

  # Raw lua
  extraConfigLuaPre = miscLua + pluginsModLua + tablineLua;

  # Neovim options
  opts = import ./opts.nix { lib = pkgs.lib; guiEnable = gui.enable; };
  highlightOverride = import ./colorscheme.nix { inherit (gui.theme) colors; };

  # Keymaps
  keymaps = import ./mapping.nix {
    inherit shell;
    lib = pkgs.lib;
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

  plugins = import ./plugins { inherit inputs pkgs user cfg gui; };
  extraPlugins = with inputs.self.packages.${pkgs.system}; [ nvim-codeshot ];
}
