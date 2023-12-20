require("trouble").setup()
require('crates').setup()
require('rainbow-delimiters.setup').setup()
require("notify").setup({
    stages = "fade_in_slide_out",
    timeout = 5000,
    background_colour = "#000000",
    -- icons = {
    --     ERROR = "<U+F057>",
    --     WARN = "<U+F06A>",
    --     INFO = "<U+F05A>",
    --     DEBUG = "<U+F188>",
    --     TRACE = "✎",
    -- },
})
require("presence"):setup({
    auto_update       = true,
    editing_text      = "Editing %s",
    workspace_text    = "Working on %s",
    neovim_image_text = "The One True Text Editor",
    main_image        = "neovim",
    log_level         = nil,
    debounce_timeout  = 30,
})
require('nvim-treesitter.configs').setup {
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
    },
    rainbow = {
        enable = true,
        extended_mode = true,
        colors = {
            '#bf616a',
            '#d08770',
            '#ebcb8b',
            '#a3be8c',
            '#88c0d0',
            '#5e81ac',
            '#b48ead',
        }
    },
}
