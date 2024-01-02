function _G.OnExit()
end

function _G.OnEnter()
end

--[
--
--      Autocommands
--
--]
vim.api.nvim_command("autocmd BufWritePre,BufWinLeave ?* silent! mkview")
vim.api.nvim_command("autocmd BufWinEnter ?* silent! loadview")
vim.api.nvim_command("autocmd CursorHold,CursorHoldI * checktime")
vim.api.nvim_command("autocmd VimEnter * lua _G.OnEnter()")
vim.api.nvim_command("autocmd VimLeavePre * lua _G.OnExit()")
--
-- vim.api.nvim_create_autocmd({"FileChangedShellPost"}, {
--   command = "require('cmp-dotenv.dotenv').load(true)",
--   pattern = ".env{.*}?",
-- })
