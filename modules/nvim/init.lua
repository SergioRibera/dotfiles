local cmd = vim.cmd
local g = vim.g

g.instant_username = "s4rch"
g.mapleader = " "
g.autoread = true
g.kommentary_create_default_mappings = false

-- Identline
g.indentLine_enabled = 1
g.indentLine_char_list = { "▏", '¦', '┆', '┊' }
g.ident_blankline_ident_level = 4
g.indent_blankline_show_current_context = true
g.indent_blankline_use_treesitter = true
g.indent_blankline_context_patterns = { 'class', 'function', 'method', 'void', 'keyword' }

--
--  Neovide Configurations
--
if g.neovide ~= nil then
    g.neovide_cursor_antialiasing = true        -- Nevovide cursor Antialiasing
    g.neovide_cursor_vfx_mode = "ripple"        -- Neovide
end

-- vim.o.guifont = 'minecraft enchantment:h13;'
vim.o.guifont = 'FiraCode Nerd Font:h13;CaskaydiaCove Nerd Font:h13'

local scopes = {o = vim.o, b = vim.bo, w = vim.wo}
local function opt(scope, key, value)
    scopes[scope][key] = value
    if scope ~= "o" then
        scopes["o"][key] = value
    end
end

opt("o", "hidden", true)
opt("o", "ignorecase", true)
opt("o", "splitbelow", true)
opt("o", "splitright", true)
opt("o", "termguicolors", true)
opt("w", "number", true)
opt("o", "numberwidth", 1)
opt("w", "cul", true)

opt("o", "mouse", "a")

opt("w", "signcolumn", "yes")
opt("o", "cmdheight", 1)

opt("o", "updatetime", 250) -- update interval for gitsigns
opt("o", "clipboard", "unnamedplus")

-- for indenline
opt("b", "expandtab", true)
opt("b", "shiftwidth", 4)

opt("w", "rnu", true)
opt("o", "modelines", 0)
opt("o", "formatoptions", "tcqrn1")
opt("o", "autoindent", true)
opt("o", "smartindent", true)
opt("o", "guicursor", "")
opt("o", "scrolloff", 1)
opt("o", "backspace", "indent,eol,start")
opt("o", "ttyfast", true)
opt("o", "showmode", true)
opt("o", "showcmd", true)
--opt("o", "laststatus", 2)
opt("o", "encoding", "utf-8")
opt("o", "hlsearch", true)
opt("o", "incsearch", true)
opt("o", "ignorecase", true)
opt("o", "smartcase", true)

function is_buffer_empty()
    -- Check whether the current buffer is empty
    return vim.fn.empty(vim.fn.expand("%:t")) == 1
end

function has_width_gt(cols)
    -- Check if the windows width is greater than a given number of columns
    return vim.fn.winwidth(0) / 2 > cols
end
