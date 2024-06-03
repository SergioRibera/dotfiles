{ cfg, lib }: let
  mapping = lib.optionalString cfg.complete ''
  mapping = {
    ["<BS>"] = cmp.mapping(function(_fallback)
      local keys = cmp_utils.smart_bs()
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
      elseif require("luasnip").expand_or_locally_jumpable() then
        require("luasnip").expand_or_jump()
      elseif require("neogen").jumpable() then
        require("neogen").jump_next()
      elseif cmp_utils.in_whitespace() then
        cmp_utils.smart_tab()
      else
        cmp.complete()
        -- else
        -- cmp.mapping.select_next_item({ behavior = require("cmp.types").cmp.SelectBehavior.Insert })
        -- fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(_fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif require("luasnip").jumpable(-1) and cmp_utils.in_snippet() then
        require("luasnip").jump(-1)
      elseif require("neogen").jumpable(true) then
        require("neogen").jump_prev()
      else
        -- cmp.mapping.select_prev_item({ behavior = require("cmp.types").cmp.SelectBehavior.Insert })
        cmp.complete()
      end
    end, { "i", "s" }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ["<CR>"] = cmp.mapping({
      i = cmp.mapping.confirm({ select = true }),
      c = cmp.mapping.confirm({ select = false }),
    }),
  },
  '';
in
''function()
  local cmp = require("cmp")

  cmp.setup({
    -- window = { documentation = { border = { "┌" "─" "┐" "│" "┘" "─" "└" "│" } } },
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "path" },
      { name = "luasnip" },
      { name = "omni" },
      { name = "nvim_lsp_signature_help" },
      { name = "crates" },
      { name = "buffer" },
      { name = "dotenv" },
    }),
    formatting = {
      fields = {
        cmp.ItemField.Kind,
        cmp.ItemField.Abbr,
        cmp.ItemField.Menu,
      },
      format = function(entry, vim_item)
        local maxwidth = 50
        local ellipsis_char = nil -- "..."
        local symbol = global_symbols[vim_item.kind] or ""
        vim_item.kind = string.format("%s", symbol)

        local maxwidth = type(maxwidth) == "function" and maxwidth() or maxwidth
        if vim.fn.strchars(vim_item.abbr) > maxwidth then
          vim_item.abbr = vim.fn.strcharpart(vim_item.abbr, 0, maxwidth)
            .. (ellipsis_char ~= nil and ellipsis_char or "")
        end

        local m = vim_item.menu and vim_item.menu or ""
        if #m > 25 then
          vim_item.menu = string.sub(m, 1, 20) .. "..."
        end

        return vim_item
      end
    },
    ${mapping}
  })
end''
