require("gitsigns").setup {
    signs = {
        add = {hl = "DiffAdd", text = "▌", numhl = "GitSignsAddNr"},
        change = {hl = "DiffChange", text = "▌", numhl = "GitSignsChangeNr"},
        delete = {hl = "DiffDelete", text = "▌", numhl = "GitSignsDeleteNr"},
        topdelete = {hl = "DiffDelete", text = "▌", numhl = "GitSignsDeleteNr"},
        changedelete = {hl = "DiffChange", text = "▌", numhl = "GitSignsChangeNr"}
    },
    keymaps = {},
    watch_index = {
        interval = 100
    },
    current_line_blame = true,
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil,
    use_decoration_api = true,
    use_internal_diff = true,
}

local cmd = vim.cmd

cmd "hi DiffAdd guifg = #81A1C1 guibg = none"
cmd "hi DiffChange guifg = #838B97 guibg = none"
cmd "hi DiffModified guifg = #C88463 guibg = none"
cmd "hi DiffDelete guifg = #D76363 guibg = none"
