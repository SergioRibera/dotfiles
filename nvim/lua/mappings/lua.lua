local function map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local opt = {}

-- dont copy any deleted text , this is disabled by default so uncomment the below mappings if you want them!
--[[

map("n", "dd", [=[ "_dd ]=], opt)
map("v", "dd", [=[ "_dd ]=], opt)
map("v", "x", [=[ "_x ]=], opt)

]]

-- copy any selected text with pressing y
map("", "<leader>c", '"+y')

--
--  Save or Quit
--
map("", "<leader>q", ':q<CR>')
map("", "<leader>w", ':w!<CR>')
map("", "<leader>wq", ':wq!<CR>')

-- OPEN TERMINALS --
map("n", "<C-x>", [[<Cmd> split term://zsh | resize 10 <CR>]], opt) -- open term bottom
