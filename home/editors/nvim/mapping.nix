{ lib
, shell
, complete
}:
let
  opts = desc: { inherit desc; silent = true; };
in
[
  # Tabs
  { key = "<C-h>"; action = ":tabprevious<Cr>"; options = opts "Go to preview tab"; }
  { key = "<C-l>"; action = ":tabnext<Cr>"; options = opts "Go to next tab"; }

  # Save or Quit
  { key = "<leader>q"; action = ":q!<CR>"; options = opts "Quit buffer"; }
  { key = "<leader>w"; action = ":w!<CR>"; options = opts "Write buffer"; }
  { key = "<leader>wq"; action = ":x<CR>"; options = opts "Write and close buffer"; }

  # help keymaps
  # register_map("n", "<Leader>hk", [[<Cmd>lua require('telescope.builtin').keymaps()<CR>]], opt, "telescope", "Show ")
  # register_map("n", "<Leader>hk", [[<Cmd>lua show_my_keymaps()<CR>]], opt, "telescope", "Show all my commands to help you")

  # Telescope
  { key = "<Leader>ff"; action = "<cmd>lua require('telescope.builtin').find_files()<CR>"; options = opts "Show and find files on workspace with preview"; }
  { key = "<Leader>lg"; action = "<cmd>lua require('telescope.builtin').live_grep()<CR>"; options = opts "Show regex content on all files on workspace"; }
] ++ lib.lists.optionals complete [
  #
  # COMPLETE VERSION
  #
  { key = "<Leader>pp"; action = "<cmd>lua require'telescope'.extensions.project.project()<CR>"; options = opts "Show regex content on all files on workspace"; }

  # Dap
  { key = "<Leader>dt"; action = "<cmd>lua require('dapui').toggle()<CR>"; options = opts "Toggle dap-ui"; }
  { key = "<Leader>db"; action = "<cmd>DapToggleBreakpoint<CR>"; options = opts "Toggle debug breakpoint"; }
  { key = "<Leader>dc"; action = "<cmd>DapContinue<CR>"; options = opts "Continue debuggin"; }
  { key = "<Leader>dr"; action = "<cmd>lua require('dapui).open({reset = true})<CR>"; options = opts "Reset dap-ui"; }

  # Take Screenshots using [sss](github:SergioRibera/sss)
  { mode = [ "v" ]; key = "<leader>ss"; action = ":SSSelected<Cr>"; options = opts "Take screenshot"; }

  # open shell
  { key = "<C-b>"; action = "<Cmd> split term://${shell.command} | resize 10 <CR>"; options = opts "Open Terminal"; }
]
