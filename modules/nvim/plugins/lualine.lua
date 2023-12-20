local lualine = require('lualine')
local navic = require('nvim-navic')

navic.setup({
    highlight = true,
    separator = ' > ',
    depth_limit = 0,
    depth_limit_indicator = '..',
    safe_output = false,
})

lualine.setup {
    options = {
        theme = 'gruvbox',
        section_separators = {'', ''},
        component_separators = { '', '' },
        disabled_filetypes = { 'NvimTree', 'Term' },
        icons_enabled = true,
    },
    sections = {
        lualine_a = { { 'mode', upper = true } },
        lualine_b = {
            { 'branch', icon = '' },
            {
                'diff',
                symbols = { added = ' ', modified = '柳 ', removed = ' ' },
                color_added = "#BBE67E",
                color_modified = "#FF8800",
                color_removed = "#DF8890",
                condition = function()
                    return vim.fn.winwidth(0) > 80
                end,
            }
        },
        lualine_c = {
            {
                'diagnostics',
                sources = { 'nvim_diagnostic' },
                symbols = { error = ' ', warn = ' ', info = ' ' },
                color_error = "#DF8890",
                color_warn = "#A3BE8C",
                color_info = "#22262C",
            },
            {
                'filename',
                icons_enabled = true,
                file_status = true,
                symbols = { modified = '[+]', readonly = '[-]' }
            },
            { ' > ', cond = navic.is_available },
            { navic.get_location, cond = navic.is_available }
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = { 'progress', 'location' },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filetype' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    extensions = {}
}
