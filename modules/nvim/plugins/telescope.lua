local telescope_actions = require("telescope.actions")
local telescope_fb_actions = require("telescope").extensions.file_browser.actions

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
        },
        file_browser = {
            grouped = true,
            mappings = {
                ["i"] = {
                    ["<C-a>"] = telescope_fb_actions.create,
                    ["<C-i>"] = telescope_fb_actions.create_from_prompt,
                    ["<C-r>"] = telescope_fb_actions.rename,
                    ["<C-m>"] = telescope_fb_actions.move,
                    ["<C-c>"] = telescope_fb_actions.copy,
                    ["<C-d>"] = telescope_fb_actions.remove,
                    ["<C-o>"] = telescope_fb_actions.open,
                    ["<C-t>"] = telescope_actions.select_tab,
                    ["<C-f>"] = telescope_fb_actions.toggle_browser,
                    ["<C-h>"] = telescope_fb_actions.toggle_hidden,
                    ["<C-s>"] = telescope_fb_actions.toggle_all,
                    ["<bs>"] = telescope_fb_actions.backspace,
                },
                ["n"] = {
                    ["a"] = telescope_fb_actions.create,
                    ["r"] = telescope_fb_actions.rename,
                    ["x"] = telescope_fb_actions.move,
                    ["c"] = telescope_fb_actions.copy,
                    ["d"] = telescope_fb_actions.remove,
                    ["o"] = telescope_fb_actions.open,
                    ["f"] = telescope_fb_actions.toggle_browser,
                    ["h"] = telescope_fb_actions.toggle_hidden,
                    ["t"] = telescope_fb_actions.toggle_all,
                },
            },
        },
    }
}

require("telescope").load_extension("file_browser")
require("telescope").load_extension("media_files")
require("telescope").load_extension("ui-select")

local opt = {noremap = true, silent = true}
-- vim.g.mapleader = " "
-- mappings
register_map("n", "<Leader>ff", [[<Cmd>lua require('telescope.builtin').find_files()<CR>]], opt, "telescope", "Show and find files on workspace with preview")

-- git
register_map("n", "<Leader>gc", [[<Cmd>lua require('telescope.builtin').git_commits()<CR>]], opt, "telescope", "Show commits on git project")
register_map("n", "<Leader>gbc", [[<Cmd>lua require('telescope.builtin').git_bcommits()<CR>]], opt, "telescope", "Show commits on current file")
register_map("n", "<Leader>gb", [[<Cmd>lua require('telescope.builtin').git_branches()<CR>]], opt, "telescope", "Show git branches, can checkout on any")
register_map("n", "<Leader>gs", [[<Cmd>lua require('telescope.builtin').git_status()<CR>]], opt, "telescope", "Lists current changes per file with diff preview and add action")
register_map("n", "<Leader>gt", [[<Cmd>lua require('telescope.builtin').git_stash()<CR>]], opt, "telescope", "Show Lists stash items in current repository with ability to apply them on Enter press")
register_map("n", "<Leader>lg", [[<Cmd>lua require('telescope.builtin').live_grep()<CR>]], opt, "telescope", "Show regex content on all files on workspace")

-- help keymaps
-- register_map("n", "<Leader>hk", [[<Cmd>lua require('telescope.builtin').keymaps()<CR>]], opt, "telescope", "Show ")
register_map("n", "<Leader>hk", [[<Cmd>lua show_my_keymaps()<CR>]], opt, "telescope", "Show all my commands to help you")
register_map("n", "<Leader>?", [[<Cmd>Cheatsheet<CR>]], opt, "telescope", "Show all cheatsheet on Neovim config")

-- Extensions
register_map(
"n",
"<Leader>n",
[[<Cmd>Telescope file_browser<CR>]],
opt, "telescope", "Find Files"
)
register_map(
"n",
"<Leader>fp",
[[<Cmd>Telescope media_files<CR>]],
opt, "telescope", "Show all media files on project with preview (if is compatible)"
)

-- highlights
cmd "hi TelescopeBorder guifg = #31314A"
cmd "hi TelescopePromptBorder guifg = #31314A"
cmd "hi TelescopeResultsBorder guifg = #31314A"
cmd "hi TelescopePreviewBorder guifg = #525865"
