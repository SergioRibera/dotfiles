require("trouble").setup()
require('crates').setup()
require("lspkind").init({
    mode = 'symbol_text',
    symbol_map = {
        Folder = "",
        Enum = "",
    }
})

local lspconfig = require('lspconfig')

local lsp = vim.lsp
local telescope = require("telescope.builtin")

local publish_diagnostics = {
    virtual_text = {
        prefix = '●',
    },
    signs = true,
    underline = true,
    update_in_insert = true
}

local signs_opts = {
    signs = {
        Error = ' ',
        Warn = ' ',
        Hint = ' ',
        Info = ' '
    },
    colors = {
        error = '#f9929b',
        warning = '#EBCB8B',
        info = '#A3BE8C',
        hint = '#b6bdca',
    },
}

local setup_sign_icons = function()
    for type, icon in pairs(signs_opts.signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end
    vim.cmd("hi DiagnosticSignError guifg=" .. signs_opts.colors.error)
    vim.cmd("hi DiagnosticVirtualTextError guifg=" .. signs_opts.colors.error)

    vim.cmd("hi DiagnosticSignWarning guifg=" .. signs_opts.colors.warning)
    vim.cmd("hi DiagnosticVirtualTextWarning guifg=" .. signs_opts.colors.warning)

    vim.cmd("hi DiagnosticSignInformation guifg=" .. signs_opts.colors.info)
    vim.cmd("hi DiagnosticVirtualTextInformation guifg=" .. signs_opts.colors.info)

    vim.cmd("hi DiagnosticSignHint guifg=" .. signs_opts.colors.hint)
    vim.cmd("hi DiagnosticVirtualTextHint guifg=" .. signs_opts.colors.hint)
end

local override_handlers = function()
    -- lsp.handlers["textDocument/codeAction"] = telescope.lsp_code_actions
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, publish_diagnostics
    )
end

local capabilities = require("cmp_nvim_lsp").default_capabilities(lsp.protocol.make_client_capabilities())
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
}

local on_attach = function(client, bufnr)
    local function buf_set_option(name, value)
        api.nvim_buf_set_option(bufnr, name, value)
    end

    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    lsp_mapping()
    if client.server_capabilities.documentSymbolProvider then
        require('nvim-navic').attach(client, bufnr)
    end

    -- Register nvim-cmp LSP source
    if client.name ~= "null-ls" then
        require("cmp_nvim_lsp").setup()
    end
end

-- Override handlers
override_handlers()
setup_sign_icons()

-- default LSP
local lsp_servers = {"bashls", "cssls", "jsonls", "html", "nil_ls", "pyright", "rnix", "tailwindcss", "taplo", "yamlls"}
for s in pairs(lsp_servers) do
    lspconfig[lsp_servers[s]].setup {
        on_attach = on_attach,
        capabilities = capabilities,
    }
end
