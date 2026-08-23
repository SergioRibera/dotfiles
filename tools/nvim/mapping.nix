{
  lib,
  shell,
  complete,
}:
let
  opts = desc: {
    inherit desc;
    silent = true;
  };
in
[
  # Tabs
  {
    key = "<C-h>";
    action = ":tabprevious<Cr>";
    options = opts "Go to preview tab";
  }
  {
    key = "<C-l>";
    action = ":tabnext<Cr>";
    options = opts "Go to next tab";
  }

  # Save or Quit
  {
    key = "<leader>q";
    action = ":q!<CR>";
    options = opts "Quit buffer";
  }
  {
    key = "<leader>w";
    action = ":w!<CR>";
    options = opts "Write buffer";
  }
  {
    key = "<leader>wq";
    action = ":x<CR>";
    options = opts "Write and close buffer";
  }

  # Telescope
  {
    key = "<Leader>hk";
    action = "<cmd>Telescope keymaps<CR>";
    options = opts "Show and find files on workspace with preview";
  }
  {
    key = "<Leader>ff";
    action = "<cmd>Telescope find_files<CR>";
    options = opts "Show and find files on workspace with preview";
  }
  {
    key = "<Leader>lg";
    action = "<cmd>Telescope live_grep<CR>";
    options = opts "Show regex content on all files on workspace";
  }
  # File Operations (create, rename, move, copy, delete)
  {
    key = "<leader>fc";
    action = ":lua vim.ui.input({prompt='New file: '}, function(name) if name then vim.cmd('edit ' .. name) end end)<CR>";
    options = opts "Create new file";
  }
  {
    key = "<leader>fd";
    action = ":lua vim.ui.input({prompt='Delete file (y/n): ', default='n'}, function(confirm) if confirm == 'y' then os.remove(vim.fn.expand('%:p')) vim.cmd('bdelete!') print('File deleted') end end)<CR>";
    options = opts "Delete current file";
  }
  {
    key = "<leader>fr";
    action = ":lua vim.ui.input({prompt='Rename to: ', default=vim.fn.expand('%:t')}, function(name) if name then local old = vim.fn.expand('%:p') local new = vim.fn.expand('%:h') .. '/' .. name os.rename(old, new) vim.cmd('edit ' .. new) vim.cmd('bdelete! ' .. old) print('Renamed to ' .. name) end end)<CR>";
    options = opts "Rename current file";
  }
  {
    key = "<leader>fm";
    action = ":lua vim.ui.input({prompt='Move to: ', default=vim.fn.expand('%:p')}, function(path) if path then local old = vim.fn.expand('%:p') os.rename(old, path) vim.cmd('edit ' .. path) vim.cmd('bdelete! ' .. old) print('Moved to ' .. path) end end)<CR>";
    options = opts "Move current file";
  }
  {
    key = "<leader>fy";
    action = ":lua vim.ui.input({prompt='Copy to: '}, function(path) if path then local old = vim.fn.expand('%:p') vim.fn.system('cp ' .. vim.fn.shellescape(old) .. ' ' .. vim.fn.shellescape(path)) print('Copied to ' .. path) end end)<CR>";
    options = opts "Copy current file";
  }
]
++ lib.lists.optionals complete [
  #
  # COMPLETE VERSION
  #
  {
    key = "<Leader>pp";
    action = "<cmd>Telescope project<CR>";
    options = opts "Open project search";
  }
  {
    key = "<Leader>gg";
    action = "<cmd>lua toggle_floating('gitui')<CR>";
    options = opts "Open gitui in floating window";
  }

  # Dap
  {
    key = "<Leader>db";
    action = "<cmd>DapToggleBreakpoint<CR>";
    options = opts "Toggle debug breakpoint";
  }
  {
    key = "<Leader>dc";
    action = "<cmd>DapContinue<CR>";
    options = opts "Continue debuggin";
  }
  {
    key = "<Leader>dr";
    action = "<cmd>lua require('dapui).open({reset = true})<CR>";
    options = opts "Reset dap-ui";
  }

  # Take Screenshots using [sss](github:SergioRibera/sss)
  {
    mode = [ "v" ];
    key = "<leader>ss";
    action = ":SSSelected<Cr>";
    options = opts "Take screenshot";
  }

  # open shell
  {
    key = "<C-b>";
    action = "<Cmd> split term://${lib.strings.concatStringsSep " " shell.command} | resize 10 <CR>";
    options = opts "Open Terminal";
  }
]
