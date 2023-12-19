require("telescope").setup {
    defaults = {
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case'
        },
        prompt_prefix = "❯ ",
        selection_caret = "❯ ",
        -- prompt_prefix = " ",
        -- selection_caret = " ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "descending",
        layout_strategy = "horizontal",
        layout_config = {
            horizontal = {
                mirror = false,
            },
            vertical = {
                mirror = false,
            },
        },
        file_sorter =  require'telescope.sorters'.get_fuzzy_file,
        file_ignore_patterns = { "^target/", "***/target/", "^node_modules/" },
        generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
        winblend = 0,
        border = {},
        borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
        color_devicons = true,
        use_less = true,
        path_display = {},
        set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
        file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
        grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
        qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
    },
    extensions = {
        media_files = {
            filetypes = {"png", "webp", "jpg", "jpeg"},
            find_cmd = "rg" -- find command (defaults to `fd`)
        },
    }
}

require("telescope").load_extension("file_browser")
require("telescope").load_extension("ui-select")

local opt = {noremap = true, silent = true}
-- vim.g.mapleader = " "
-- mappings
_G.register_map("n", "<Leader>ff", [[<Cmd>lua require('telescope.builtin').find_files()<CR>]], opt, "telescope", "Show and find files on workspace with preview")

-- git
_G.register_map("n", "<Leader>gc", [[<Cmd>lua require('telescope.builtin').git_commits()<CR>]], opt, "telescope", "Show commits on git project")
_G.register_map("n", "<Leader>gbc", [[<Cmd>lua require('telescope.builtin').git_bcommits()<CR>]], opt, "telescope", "Show commits on current file")
_G.register_map("n", "<Leader>gb", [[<Cmd>lua require('telescope.builtin').git_branches()<CR>]], opt, "telescope", "Show git branches, can checkout on any")
_G.register_map("n", "<Leader>gs", [[<Cmd>lua require('telescope.builtin').git_status()<CR>]], opt, "telescope", "Lists current changes per file with diff preview and add action")
_G.register_map("n", "<Leader>gt", [[<Cmd>lua require('telescope.builtin').git_stash()<CR>]], opt, "telescope", "Show Lists stash items in current repository with ability to apply them on Enter press")
_G.register_map("n", "<Leader>lg", [[<Cmd>lua require('telescope.builtin').live_grep()<CR>]], opt, "telescope", "Show regex content on all files on workspace")

-- help keymaps
-- _G.register_map("n", "<Leader>hk", [[<Cmd>lua require('telescope.builtin').keymaps()<CR>]], opt, "telescope", "Show ")
_G.register_map("n", "<Leader>hk", [[<Cmd>lua show_my_keymaps()<CR>]], opt, "telescope", "Show all my commands to help you")
_G.register_map("n", "<Leader>?", [[<Cmd>Cheatsheet<CR>]], opt, "telescope", "Show all cheatsheet on Neovim config")

-- Extensions
_G.register_map("n", "<Leader>se", [[<Cmd>Telescope emoji<CR>]], opt, "telescope", "Show emojis for easy implementation")
_G.register_map(
"n",
"<Leader>fp",
[[<Cmd>lua require('telescope').extensions.media_files.media_files()<CR>]],
opt, "telescope", "Show all media files on project with preview (if is compatible)"
)

-- highlights
local cmd = vim.cmd

cmd "hi TelescopeBorder guifg = #31314A"
cmd "hi TelescopePromptBorder guifg = #31314A"
cmd "hi TelescopeResultsBorder guifg = #31314A"
cmd "hi TelescopePreviewBorder guifg = #525865"
