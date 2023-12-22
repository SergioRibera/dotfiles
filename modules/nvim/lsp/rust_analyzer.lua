local rust_analyzer_opts = {
    assist = {
        importEnforceGranularity = true,
        importPrefix = "create"
    },
    cache = {
        warmup = false,
    },
    cachePriming = {
        enable = false,
    },
    cargo = {
        allFeatures = true,
        buildScripts = {
            enable = true,
        },
    },
    completion = {
        autoimport = {
            enable = true,
        },
    },
    diagnostics = {
        experimental = {
            enable = true,
        },
    },
    imports = {
        granularity = {
            group = "module",
        },
        prefix = "self",
    },
    procMacros = {
        enable = true,
    },
}

require("lspconfig").rust_analyzer.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        ["rust-analyzer"] = rust_analyzer_opts
    },
})
