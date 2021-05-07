vim.cmd [[packadd nvim-lspconfig]]
vim.cmd [[packadd nvim-compe]]
require 'lsp.servers'

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false,
        signs = true,
        underline = true,
        update_in_insert = true
    }
)
vim.lsp.handlers['textDocument/hover'] = function(_, method, result)
    vim.lsp.util.focusable_float(method, function()
        if not (result and result.contents) then
            return
            -- return { 'No information available' }
        end
        local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
        markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)
        if vim.tbl_isempty(markdown_lines) then
            return
            -- return { 'No information available (Not have Documentation)' }
        end
        local bufnr, winnr = vim.lsp.util.fancy_floating_markdown(markdown_lines, {
            pad_left = 1; pad_right = 1;
        })
        vim.lsp.util.close_preview_autocmd({"CursorMoved", "BufHidden"}, winnr)
        return bufnr, winnr
  end)
end
vim.fn.sign_define("LspDiagnosticsSignError", {text = "", texthl = "GruvboxRed"})
vim.fn.sign_define("LspDiagnosticsSignWarning", {text = "", texthl = "GruvboxYellow"})
vim.fn.sign_define("LspDiagnosticsSignInformation", {text = "", texthl = "GruvboxBlue"})
vim.fn.sign_define("LspDiagnosticsSignHint", {text = "", texthl = "GruvboxAqua"})
