require("lspconfig").lua_ls.setup({
    settings = {
        Lua = {
            hint = {
                enable = true,
            },
            completion = { callSnippet = "Disable" },
            diagnostics = {
                globals = {
                    "vim",
                    "describe",
                    "pending",
                    "it",
                    "before_each",
                    "after_each",
                    "setup",
                    "teardown",
                },
            },
            runtime = {
                version = "LuaJIT",
                path = vim.split(package.path, ";")
            },
            workspace = {
                checkThirdParty = false,
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                },
                maxPreload = 2000,
            },
        },
    },
    on_attach = on_attach,
    capabilities = capabilities,
})
