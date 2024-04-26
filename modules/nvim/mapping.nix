{ lib
, shell
, complete
}:
let
  opts = desc: { inherit desc; silent = true; };
in
{
  maps = [
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

    # Extensions
    { key = "<Leader>n"; action = "<cmd>Telescope file_browser<CR>"; options = opts "Find Files"; }
  ] ++ lib.lists.optionals complete [
    #
    # COMPLETE VERSION
    #
    # Telescope
    {
      key = "<Leader>fp";
      action = "<cmd>Telescop media_files<CR>";
      options = opts "Show all media files on project with preview";
    }

    # Take Screenshots using [sss](github:SergioRibera/sss)
    # { mode = [ "v" ]; key = "<leader>ps"; action = ":TakeScreenShot<Cr>"; options = opts "Take screenshot"; }

    # open shell
    { key = "<C-b>"; action = "<Cmd> split term://${shell} | resize 10 <CR>"; options = opts "Open Terminal"; }
  ];
  events = {
    #
    # LSP ONLY IS AVAILABLE ON COMPLETE VERSION
    #
    LspAttach = lib.lists.optionals complete [
      # Codeactions
      { key = "<leader>ga"; action = "<cmd>lua vim.lsp.buf.code_action()<Cr>"; options = opts "Show code actions on line"; }
      # telescope definitions
      { key = "<leader>gD"; action = "<Cmd>lua require('telescope.builtin').lsp_definitions()<CR>"; options = opts "Show definitions on project"; }
      # Hover information
      { key = "<leader>K"; action = "<Cmd>lua vim.lsp.buf.hover()<CR>"; options = opts "Show details for element where hold cursor"; }
      # Show implementations
      { key = "<leader>gi"; action = "<cmd>lua require'telescope.builtin'.lsp_implementations()<CR>"; options = opts "Show implementations"; }
      # Rename
      { key = "<leader>rn"; action = "<cmd>lua vim.lsp.buf.rename()<CR>"; options = opts "Rename definition"; }
      # Telescope References
      { key = "<leader>gr"; action = "<cmd>lua require('telescope.builtin').lsp_references()<CR>"; options = opts "Show all references of definition"; }
      # Format File
      { key = "<C-f>"; action = "<Cmd>lua vim.lsp.buf.format({ tabSize = vim.o.shiftwidth or 4, aync = true })<CR>"; options = opts "Format the current document with LSP"; }
      # Floating Diagnostic
      { key = "<leader>e"; action = "<cmd>lua vim.diagnostic.open_float()<CR>"; options = opts "Show diagnostic on current line"; }

      # Generate documentation
      { key = "<leader>nf"; action = ":lua require('neogen').generate()<CR>"; options = opts "Intellisense for generate documentation"; }
    ];
  };
}
