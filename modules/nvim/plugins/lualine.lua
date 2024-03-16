local lualine = require('lualine')
local navic = require('nvim-navic')

require('lsp-progress').setup()

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
            {
                'branch',
                icon = '',
                on_click = function(n, b)
                    if n ~= 1 then
                        return
                    end
                    if b == 'l' or b == 'left' then
                        vim.cmd("Telescope git_branches")
                    end
                    if b == 'r' or b == 'right' then
                        vim.cmd("Telescope git_commits")
                    end
                end
            },
            {
                'diff',
                symbols = { added = ' ', modified = '柳', removed = ' ' },
                color_added = theme.base0B,
                color_modified = theme.base03,
                color_removed = theme.base08,
                condition = function()
                    return vim.fn.winwidth(0) > 80
                end,
                on_click = function(n, b)
                    if n ~= 1 then
                        return
                    end
                    if b == 'l' or b == 'left' then
                        vim.cmd("<Plug>Telescope git_status<Cr>")
                    end
                    if b == 'r' or b == 'right' then
                        vim.cmd("<Plug>Telescope git_stash<Cr>")
                    end
                end
            }
        },
        lualine_c = {
            {
                'diagnostics',
                sources = { 'nvim_diagnostic' },
                symbols = { error = ' ', warn = ' ', info = ' ' },
                color_error = theme.base08,
                color_warn = theme.base0E,
                color_info = theme.base05,
                on_click = function(n, b)
                    if n ~= 1 then
                        return
                    end
                    if b == 'l' or b == 'left' then
                        vim.cmd(":Trouble<Cr>")
                    end
                end
            },
            {
                'filename',
                icons_enabled = true,
                file_status = true,
                symbols = { modified = '•', readonly = ''}
            },
            { ' > ', cond = navic.is_available },
            { navic.get_location, cond = navic.is_available }
        },
        lualine_x = {},
        lualine_y = {
            {
                function() -- Setup lsp-progress component
                    return require("lsp-progress").progress({
                        max_size = 80,
                        format = function(messages)
                            if #messages > 0 then
                                return table.concat(messages, " ")
                            end
                            return ""
                        end,
                    })
                end,
                icon = { "", align = "right" },
            },
        },
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

vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
vim.api.nvim_create_autocmd("User", {
    group = "lualine_augroup",
    pattern = "LspProgressStatusUpdated",
    callback = require("lualine").refresh,
})
