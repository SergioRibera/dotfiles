{ pkgs
, cfg
, user
, gui
, ...
}:
with pkgs.lib;
let
  # import complete config
  # nvimLsp = import ../lsp { inherit pkgs; };
  mykeymaps = import ../mapping.nix {
    lib = pkgs.lib;
    shell = user.shell;
    complete = cfg.complete;
  };
  utilsLua = builtins.readFile ../utils.lua;
  tablineLua = (import ../tabline.nix { inherit (gui.theme) colors; });
  # modPluginsLua = optionalString cfg.complete (builtins.readFile ../plugins/mod.lua);
  # miscLua = optionalString cfg.complete (builtins.readFile ../misc.lua);
  cmpUtilsLua = optionalString cfg.complete (builtins.readFile ../plugins/cmp.lua);
in
{
  # enable = true;
  enableMan = false;
  # defaultEditor = true;
  viAlias = true;
  vimAlias = true;

  # Packages
  extraPackages = [ pkgs.ripgrep pkgs.fd ]
    ++ lists.optionals (gui.enable && cfg.neovide) [ pkgs.neovide ];

  # Raw lua
  extraConfigLuaPre = utilsLua
    + cmpUtilsLua
    # + miscLua
    # + modPluginsLua
    + tablineLua;

  # Neovim options
  opts = import ../opts.nix { lib = pkgs.lib; guiEnable = gui.enable; };
  # Colorscheme
  highlightOverride = import ../colorscheme.nix { inherit (gui.theme) colors; };
  # Keymaps
  keymaps = mykeymaps.maps;
  keymapsOnEvents = mykeymaps.events;

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
  extraPlugins = [
    # Editor
    (pkgs.vimUtils.buildVimPlugin {
      pname = "nvim-surround";
      version = "2024-04-11";
      src = pkgs.fetchFromGitHub {
        owner = "kylechui";
        repo = "nvim-surround";
        rev = "f7bb9fc4d68ad319d94b1d98ed16f279811f5cc8";
        sha256 = "sha256-zi6FtK//HlBhndEYmzUQQtHR4ix73eAxHyB2Z3kmQz8=";
      };
      meta.homepage = "https://github.com/kylechui/nvim-surround";
    })
  ] ++ pkgs.lib.lists.optionals cfg.complete [
    # Editor
    (pkgs.vimUtils.buildVimPlugin {
      pname = "lsp-progress.nvim";
      version = "2024-04-02";
      src = pkgs.fetchFromGitHub {
        owner = "linrongbin16";
        repo = "lsp-progress.nvim";
        rev = "47abfc74f21d6b4951b7e998594de085d6715791";
        sha256 = "sha256-flM49FBI1z7Imvk5wZW44N9IyLFRIswIe+bskOZ2CT0=";
      };
      meta.homepage = "https://github.com/linrongbin16/lsp-progress.nvim";
    })
    (pkgs.vimUtils.buildVimPlugin {
      pname = "vim-wakatime";
      version = "2024-04-11";
      src = pkgs.fetchFromGitHub {
        owner = "wakatime";
        repo = "vim-wakatime";
        rev = "5d11a253dd1ecabd4612a885175216032d814300";
        sha256 = "sha256-1w6M6hnDOu4ruAUnUcAbFViUzZDGslrdYXx5jVrspc8=";
      };
      meta.homepage = "https://github.com/wakatime/vim-wakatime";
    })
  ];
}
