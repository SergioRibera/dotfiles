require("lspconfig").omnisharp.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
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
            locationPaths = {}
        }
    }
})
