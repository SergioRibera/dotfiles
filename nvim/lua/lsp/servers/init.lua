require 'lsp.servers.omnisharp'
require 'lsp.servers.sumneko_lua'
local onattach = require 'lsp.utils'.onattach

local lspconf = require "lspconfig"
local servers = {
    "html",
    "cssls",
    "tsserver",
    "pyright",
    "bashls",
    "jsonls",
    "rls",
    "yamlls"
}
for k, lang in pairs(servers) do
    lspconf[lang].setup {
        on_attach = onattach,
        root_dir = vim.loop.cwd
    }
end

--[[
--
--      Rust Servers
--
--]]
lspconf.rust_analyzer.setup {
    on_attach = on_attach,
    settings = {
        ["rust-analyzer"] = {
            assist = {
                importMergeBehavior = "last",
                importPrefix = "by_self",
            },
            cargo = {
                loadOutDirsFromCheck = true
            },
            procMacro = {
                enable = true
            },
        }
    }
}
