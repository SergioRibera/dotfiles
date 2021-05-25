local settings_manager = require '../misc-utils/settings'
settings_manager.load_settings()
local function map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

--
--  Cycle Themes
--
local base16 = require "base16"
local themes_names = {
    "material", "onedark", "nord",
}
local log_cycle_theme = false
local base16_position = settings_manager.get_value("current_theme", 1)
base16_position = (base16_position - 1 % #themes_names) + 1
base16(base16.themes[themes_names[base16_position]], true)

function cycle_teme ()
    base16_position = (base16_position % #themes_names) + 1
    base16(base16.themes[themes_names[base16_position]], true)
    require("lua/misc-utils/settings").set_value("current_theme", base16_position)
    if log_cycle_theme == true then
        print(base16_position)
        print("Theme changed to: " .. themes_names[base16_position])
    end
end



--
--  Mappings
--

map("", "<leader>tn", ":lua cycle_teme()<Cr>")
map("", "<C-h>", ":tabprevious<Cr>") -- Move to prev tab
map("", "<C-l>", ":tabnext<Cr>") -- Move to next tab
map("", "<leader>y", '"+y') -- Copy any selected text
map("", "<leader>p", '"+p') -- Paste any text
map("", "<leader>ws", ":split<Cr>") -- Open Split windows
map("", "<leader>wh", ":vsplit<Cr>") -- Open Vertical split windows
map("", "<leader>ps", ":TakeScreenShot<Cr>") -- Take Screenshot (require SergioRibera/vim-screenshot plugin)
map("n", "<leader>r", ":NvimTreeRefresh<Cr>", { noremap = true })
-- Kommentary
map("n", "<leader>cc", "<Plug>kommentary_line_default", {})
map("n", "<leader>c", "<Plug>kommentary_motion_default", {})
map("v", "<leader>c", "<Plug>kommentary_visual_default", {})

-- Snippets enable jump to next cursor
map('i', '<TAB>', 'v:lua.tab_complete()', { expr = true, noremap = false })

map('i', '<S-TAB>', 'pumvisible() ? "<C-p>" : vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<S-TAB>"', {
  expr = true,
  noremap = false
})
map('s', '<TAB>', 'vsnip#available(1)  ? "<Plug>(vsnip-expand-or-jump)" : "<TAB>"', {
  expr = true,
  noremap = false
})
map('s', '<S-TAB>', 'vsnip#available(-1)  ? "<Plug>(vsnip-jump-prev)" : "<S-TAB>"', {
  expr = true,
  noremap = false
})

--
--  Save or Quit
--
map("", "<leader>q", ':q<CR>')
map("", "<leader>w", ':w<CR>')
map("", "<leader>wq", ':wq<CR>')

-- OPEN TERMINALS --
map("n", "<C-x>", [[<Cmd> split term://zsh | resize 10 <CR>]], {}) -- open term bottom

module(..., package.seeall)
