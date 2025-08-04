-- Custom show keymaps
local telescope_finders = require "telescope.finders"
local telescope_pickers = require "telescope.pickers"
local telescope_config = require("telescope.config").values
local telescope_entry_display = require('telescope.pickers.entry_display')
local floating_win = nil
local floating_buf = nil

function _G.close_floating()
  if floating_win and vim.api.nvim_win_is_valid(floating_win) then
    vim.api.nvim_win_close(floating_win, true)
    floating_win = nil
    floating_buf = nil
    return
  end
end

function _G.toggle_floating(cmd, opts)
  close_floating()
  local w = opts and opts.width or 0.7
  local h = opts and opts.height or 0.7
  local width = math.floor(vim.o.columns * w)
  local height = math.floor(vim.o.lines * h)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  floating_buf = vim.api.nvim_create_buf(false, true)

  local opts = {
    style = 'minimal',
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    border = 'rounded'
  }

  floating_win = vim.api.nvim_open_win(floating_buf, true, opts)

  vim.api.nvim_buf_set_name(floating_buf, 'command-floating')
  vim.api.nvim_set_option_value('filetype', cmd[0] or cmd, { buf = floating_buf })
  -- vim.api.nvim_set_option_value('buftype', 'terminal', { win = floating_win })
  vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = floating_buf })

  if opts and opts.exit_with_scape then
    vim.api.nvim_buf_set_keymap(floating_buf, 't', '<Esc>', '<C-\\><C-n>:lua _G.close_floating()<CR>',
      {noremap = true, silent = true})
  end

  vim.api.nvim_buf_set_keymap(floating_buf, 'n', 'q', ':lua _G.close_floating()<CR>',
    {noremap = true, silent = true})

  vim.fn.jobstart(cmd, {
    term = true,
    cwd = vim.fn.getcwd(),
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        close_floating()
      end
    end
  })

  vim.cmd('startinsert')
end



