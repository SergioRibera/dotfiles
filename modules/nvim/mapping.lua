-- Set Globals
_G.my_mapping_table = {}

-- [
--
--      Basic Global funcitonality
--
-- ]
local mapping_table_contains = function(t, v)
    for _, value in ipairs(t) do
        if value.mode == v.mode and value.lhs == v.lhs and value.category == v.category then
            return true
        end
    end
    return false
end
local register_map = function(m, ls, rs, opts, c, d)
    local options = {}
    local desc = opts.desc or d or ""

    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    if m == "" then
        m = "n"
    end
    if type(rs) == "string" then
        vim.keymap.set(m, ls, rs, options)
        -- vim.api.nvim_set_keymap(m, ls, rs, options)
    end
    local data = { mode = m, lhs = ls, rhs = rs, options = opts, category = c, description = desc }
    if not mapping_table_contains(_G.my_mapping_table, data) then
        table.insert(_G.my_mapping_table, data)
    end
end

local lsp_mapping = function()
    local opts = { silent = true }
    register_map("n", "<leader>ga", "<cmd>lua vim.lsp.buf.code_action()<Cr>", opts, "lsp", "Show code actions on line")
    register_map("n", "<leader>gD", "<Cmd>lua require'telescope.builtin'.lsp_definitions()<CR>", opts, "lsp",
        "Show definitions on project")
    register_map("n", "<leader>gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts, "lsp", "Show definitions on current file")
    register_map("n", "<leader>K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts, "lsp", "Show details for element where hold cursor")
    register_map("n", "<leader>gi", "<cmd>lua require'telescope.builtin'.lsp_implementations()<CR>", opts, "lsp",
        "Show implementations")
    register_map("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts, "lsp", "")
    register_map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts, "lsp", "Rename definition")
    register_map("n", "<leader>gr", "<cmd>lua require'telescope.builtin'.lsp_references()<CR>", opts, "lsp",
        "Show all references of definition")
    register_map("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts, "lsp", "Show diagnostic on current line")
    register_map("n", "<leader>ws", [[<Cmd>lua require('telescope.builtin').lsp_workspace_symbols()<CR>]], opts, "telescope",
        "Show all symbols on workspace")
    register_map("n", "<C-f>", [[<Cmd>lua vim.lsp.buf.format({ tabSize = vim.o.shiftwidth or 4, aync = true })<CR>]], opts, "lsp",
        "Format the current document with LSP")
    register_map("n", "<leader>nf", ":lua require('neogen').generate()<CR>", opts, "generate",
        "Intellisense for generate documentation")
    -- register_map("n", "q", "<cmd>lua require'telescope.builtin'.loclist()<CR>", opts, "lsp", "")
end

-- [
--
--      OPEN TERMINALS
--
-- ]
local os_type = vim.bo.fileformat:upper()
local term = 'bash'
if os_type == 'UNIX' or os_type == 'MAC' then
    -- Detect if exists a command
    local default_terminal = vim.fn.expand("$SHELL")
    if default_terminal:find("zsh") then
        term = "zsh"
    elseif default_terminal:find('fish') then
        term = "fish"
    else
        term = "bash"
    end
else
    term = "powershell"
end
-- open term bottom
register_map("n", "<C-b>", "<Cmd> split term://" .. term .. " | resize 10 <CR>", {}, "terminal",
    "Open new " .. term .. " terminal on bottom")

--
--  Mappings
--
register_map("n", "<C-h>", ":tabprevious<Cr>", {}, "tabs", "Go to preview tab")                                         -- Move to prev tab
register_map("n", "<C-l>", ":tabnext<Cr>", {}, "tabs", "Go to next tab")                                                -- Move to next tab
register_map("v", "<leader>ps", ":TakeScreenShot<Cr>", {}, "screenshot", "Take screenshot (SergioRibera/nvim-silicon)") -- Take Screenshot (require SergioRibera/vim-screenshot plugin)

--
--  Save or Quit
--
register_map("n", "<leader>q", ':q!<CR>', {}, "save", "Quit buffer")
register_map("n", "<leader>w", ':w!<CR>', {}, "save", "Write buffer")
register_map("n", "<leader>wq", ':x<CR>', {}, "save", "Write and close buffer")