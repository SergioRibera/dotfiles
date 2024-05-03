{ inputs
, pkgs
, cfg
, user
, gui
, ...
}:
with pkgs.lib;
let
  tablineLua = import ../tabline.nix;
  cmpUtilsLua = optionalString cfg.complete (builtins.readFile ../plugins/cmp.lua);
  extraPlugins = optionalString cfg.complete (builtins.readFile ../plugins/mod.lua);
in
{
  enableMan = false;
  # defaultEditor = true;
  viAlias = true;
  vimAlias = true;

  # Packages
  extraPackages = [ pkgs.ripgrep pkgs.fd ]
    ++ lists.optionals (gui.enable && cfg.neovide) [ pkgs.neovide ];
    # ++ lists.optionals cfg.complete [ pkgs.gdb ];

  # Raw lua
  extraConfigLuaPre = cmpUtilsLua
    + tablineLua
    + optionalString cfg.complete extraPlugins;

  # Neovim options
  opts = import ../opts.nix { lib = pkgs.lib; guiEnable = gui.enable; };
  # Colorscheme
  highlightOverride = import ../colorscheme.nix { inherit (gui.theme) colors; };
  # Keymaps
  keymaps = import ../mapping.nix {
    lib = pkgs.lib;
    shell = user.shell;
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
    # Show wich-key on startup or blank buffers
    {
      event = [ "VimEnter" "BufNewFile" ];
      pattern = [ "*" ];
      callback = {
        __raw = ''
          function()
            if vim.fn.empty(vim.fn.expand('%:t')) == 1 then
              vim.cmd("WhichKey")
            end
          end
        '';
      };
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
  globals = import ../globals.nix {
    lib = pkgs.lib;
    colors = gui.theme.colors;
    username = user.username;
    complete = cfg.complete;
  };

  # Esential plugins
  plugins = import ../plugins { inherit pkgs user cfg gui; };

  # Plugins from GitHub
  extraPlugins = with inputs.self.packages.${pkgs.system}; [
    # Editor
    nvim-surround
    nvim-cmp-dotenv
  ] ++ pkgs.lib.lists.optionals cfg.complete [
    # Editor
    nvim-lsp-progress
    nvim-wakatime
    nvim-codeshot
  ];
}
