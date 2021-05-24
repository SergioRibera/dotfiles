local lspconfig = require('lspconfig')
local pid = vim.fn.getpid()

USER = "/home/" .. vim.fn.expand("$USER")
local omnisharp_bin = USER .. "/.omnisharp/run"

local exclude_patterns = {
    '**/node_modules/**/*',
    '**/bin/**/*',
    '**/obj/**/*',
    '/tmp/**/*'
}

lspconfig.omnisharp.setup {
    cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(pid) },
    filetypes = {'cache', 'cs', 'csproj', 'dll', 'nuget', 'props', 'sln', 'targets'},
    on_attach = on_attach,
    capabilities = _G.capabilities,
    settings = {
        FileOptions = {
            ExcludeSearchPatterns = exclude_patterns,
            SystemExcludeSearchPatterns = exclude_patterns
        },
        FormattingOptions = {
            EnableEditorConfigSupport = true
        },
        ImplementTypeOptions = {
            InsertionBehavior = 'WithOtherMembersOfTheSameKind',
            PropertyGenerationBehavior = 'PreferAutoProperties'
        },
        RenameOptions = {
            RenameInComments = true,
            RenameInStrings  = true,
            RenameOverloads  = true
        },
        RoslynExtensionsOptions = {
            EnableAnalyzersSupport = true,
            EnableDecompilationSupport = true,
            EnableImportCompletion = true,
            locationPaths= {
                "$HOME/Aplicaciones/Unity/2019.4.15f1/Editor/Data/Managed/**.dll"
            }
        }
    }
}

