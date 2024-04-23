local cmp_utils = {};
cmp_utils.rhs = function(rhs_str)
  return vim.api.nvim_replace_termcodes(rhs_str, true, true, true)
end
--  -- Returns the current column number.
cmp_utils.column = function()
  local _, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col
end

cmp_utils.in_snippet = function()
  local session = require('luasnip.session')
  local node = session.current_nodes[vim.api.nvim_get_current_buf()]
  if not node then
    return false
  end
  local snippet = node.parent.snippet
  local snip_begin_pos, snip_end_pos = snippet.mark:pos_begin_end()
  local pos = vim.api.nvim_win_get_cursor(0)
  if pos[1] - 1 >= snip_begin_pos[1] and pos[1] - 1 <= snip_end_pos[1] then
    return true
  end
end

-- Returns true if the cursor is in leftmost column or at a whitespace
-- character.
cmp_utils.in_whitespace = function()
  local col = cmp_utils.column()
  return col == 0 or vim.api.nvim_get_current_line():sub(col, col):match('%s')
end

cmp_utils.shift_width = function()
  if vim.o.softtabstop <= 0 then
    return vim.fn.shiftwidth()
  else
    return vim.o.softtabstop
  end
end
-- Complement to `smart_tab()`.
--
-- When 'noexpandtab' is set (ie. hard tabs are in use), backspace:
--
--    - On the left (ie. in the indent) will delete a tab.
--    - On the right (when in trailing whitespace) will delete enough
--      spaces to get back to the previous tabstop.
--    - Everywhere else it will just delete the previous character.
--
-- For other buffers ('expandtab'), we let Neovim behave as standard and that
-- yields intuitive behavior.
cmp_utils.smart_bs = function()
  if vim.o.expandtab then
    return cmp_utils.rhs('<BS>')
  else
    local col = cmp_utils.column()
    local line = vim.api.nvim_get_current_line()
    local prefix = line:sub(1, col)
    local in_leading_indent = prefix:find('^%s*$')
    if in_leading_indent then
      return cmp_utils.rhs('<BS>')
    end
    local previous_char = prefix:sub(#prefix, #prefix)
    if previous_char ~= ' ' then
      return cmp_utils.rhs('<BS>')
    end
    -- Delete enough spaces to take us back to the previous tabstop.
    --
    -- Originally I was calculating the number of <BS> to send, but
    -- Neovim has some special casing that causes one <BS> to delete
    -- multiple characters even when 'expandtab' is off (eg. if you hit
    -- <BS> after pressing <CR> on a line with trailing whitespace and
    -- Neovim inserts whitespace to match.
    --
    -- So, turn 'expandtab' on temporarily and let Neovim figure out
    -- what a single <BS> should do.
    --
    -- See `:h i_CTRL-\_CTRL-O`.
    return cmp_utils.rhs('<C-\\><C-o>:set expandtab<CR><BS><C-\\><C-o>:set noexpandtab<CR>')
  end
end

-- In buffers where 'noexpandtab' is set (ie. hard tabs are in use), <Tab>:
--
--    - Inserts a tab on the left (for indentation).
--    - Inserts spaces everywhere else (for alignment).
--
-- For other buffers (ie. where 'expandtab' applies), we use spaces everywhere.
cmp_utils.smart_tab = function()
  local keys = nil
  if vim.o.expandtab then
    keys = '<Tab>' -- Neovim will insert spaces.
  else
    local col = cmp_utils.column()
    local line = vim.api.nvim_get_current_line()
    local prefix = line:sub(1, col)
    local in_leading_indent = prefix:find('^%s*$')
    if in_leading_indent then
      keys = '<Tab>' -- Neovim will insert a hard tab.
    else
      -- virtcol() returns last column occupied, so if cursor is on a
      -- tab it will report `actual column + tabstop` instead of `actual
      -- column`. So, get last column of previous character instead, and
      -- add 1 to it.
      local sw = cmp_utils.shift_width()
      local previous_char = prefix:sub(#prefix, #prefix)
      local previous_column = #prefix - #previous_char + 1
      local current_column = vim.fn.virtcol({ vim.fn.line('.'), previous_column }) + 1
      local remainder = (current_column - 1) % sw
      local move = remainder == 0 and sw or sw - remainder
      keys = (' '):rep(move)
    end
  end

  vim.api.nvim_feedkeys(cmp_utils.rhs(keys), 'nt', true)
end
