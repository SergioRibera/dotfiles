local cmp = require('cmp')
local lspkind = require('lspkind')
local luasnip = require('luasnip')
local neogen = require('neogen')
require("luasnip.loaders.from_vscode").lazy_load()
neogen.setup({
  enabled = true,
  snippet_engine = "luasnip"
})

vim.o.completeopt = "menu,menuone,noselect"

-- Local functions
local rhs = function(rhs_str)
  return vim.api.nvim_replace_termcodes(rhs_str, true, true, true)
end
--  -- Returns the current column number.
local column = function()
  local _line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col
end
local in_snippet = function()
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
local in_whitespace = function()
  local col = column()
  return col == 0 or vim.api.nvim_get_current_line():sub(col, col):match('%s')
end

local shift_width = function()
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
local smart_bs = function()
  if vim.o.expandtab then
    return rhs('<BS>')
  else
    local col = column()
    local line = vim.api.nvim_get_current_line()
    local prefix = line:sub(1, col)
    local in_leading_indent = prefix:find('^%s*$')
    if in_leading_indent then
      return rhs('<BS>')
    end
    local previous_char = prefix:sub(#prefix, #prefix)
    if previous_char ~= ' ' then
      return rhs('<BS>')
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
    return rhs('<C-\\><C-o>:set expandtab<CR><BS><C-\\><C-o>:set noexpandtab<CR>')
  end
end

-- In buffers where 'noexpandtab' is set (ie. hard tabs are in use), <Tab>:
--
--    - Inserts a tab on the left (for indentation).
--    - Inserts spaces everywhere else (for alignment).
--
-- For other buffers (ie. where 'expandtab' applies), we use spaces everywhere.
local smart_tab = function(opts)
  local keys = nil
  if vim.o.expandtab then
    keys = '<Tab>' -- Neovim will insert spaces.
  else
    local col = column()
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
      local sw = shift_width()
      local previous_char = prefix:sub(#prefix, #prefix)
      local previous_column = #prefix - #previous_char + 1
      local current_column = vim.fn.virtcol({ vim.fn.line('.'), previous_column }) + 1
      local remainder = (current_column - 1) % sw
      local move = remainder == 0 and sw or sw - remainder
      keys = (' '):rep(move)
    end
  end

  vim.api.nvim_feedkeys(rhs(keys), 'nt', true)
end
local cmp_border = {
  { "┌", "Normal" },
  { "─", "Normal" },
  { "┐", "Normal" },
  { "│", "Normal" },
  { "┘", "Normal" },
  { "─", "Normal" },
  { "└", "Normal" },
  { "│", "Normal" },
}

--[
--
--      Cmp Config
--
--]
cmp.setup({
  window = {
    documentation = cmp.config.window.bordered({
      border = cmp_border,
    }),
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  formatting = {
    fields = {
      cmp.ItemField.Kind,
      cmp.ItemField.Abbr,
      cmp.ItemField.Menu,
    },
    format = lspkind.cmp_format({
      with_text = false,
      maxwidth = 50,
      before = function(_, vim_item)
        local m = vim_item.menu and vim_item.menu or ""
        if #m > 25 then
          vim_item.menu = string.sub(m, 1, 20) .. "..."
        end
        return vim_item
      end,
    })
  },
  mapping = {
    ['<BS>'] = cmp.mapping(function(_fallback)
      local keys = smart_bs()
      vim.api.nvim_feedkeys(keys, 'nt', true)
    end, { 'i', 's' }),
    ["<Tab>"] = cmp.mapping(function(_fallback)
      if cmp.visible() then
        -- If there is only one completion candidate, use it.
        if #cmp.get_entries() == 1 then
          cmp.confirm({ select = true })
        else
          cmp.select_next_item()
        end
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      elseif neogen.jumpable() then
        neogen.jump_next()
      elseif in_whitespace() then
        smart_tab()
      else
        cmp.complete()
        -- else
        -- cmp.mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Insert })
        -- fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(_fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) and in_snippet() then
        luasnip.jump(-1)
      elseif neogen.jumpable(true) then
        neogen.jump_prev()
      else
        -- cmp.mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert })
        cmp.complete()
      end
    end, { "i", "s" }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<CR>'] = cmp.mapping({
      i = cmp.mapping.confirm({ select = true }),
      c = cmp.mapping.confirm({ select = false }),
    }),
  },
  sources = cmp.config.sources({
    {
      name = "nvim_lsp",
      entry_filter = function(entry)
        return not (entry:get_kind() == require("cmp.types").lsp.CompletionItemKind.Snippet
          and entry.source:get_debug_name() == "nvim_lsp:emmet_ls")
      end,
    },
    { name = 'path' },
    { name = 'luasnip' },
    { name = 'omni' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'crates' },
  }, {
    { name = 'buffer' },
    { name = 'dotenv' },
  }),
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

cmd("autocmd FileType TelescopePrompt lua require('cmp').setup.buffer { enabled = false }")
