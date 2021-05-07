local ts_config = require("nvim-treesitter.configs")

ts_config.setup {
    ensure_installed = {
        "c_sharp",
        "javascript",
        "tsx",
        "typescript",
        "html",
        "php",
        "css",
        "bash",
        "lua",
        "json",
        "python",
        "cpp",
        "rust",
        "dart",
        "regex"
    },
    highlight = {
        enable = true,
        use_languagetree = true
    }
}
