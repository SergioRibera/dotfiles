{ cfg, lib }: {
  # cmdline = {
  #   "/" = {
  #     sources = [
  #       { name = "buffer"; }
  #     ];
  #   };
  #   ":" = {
  #     sources = [
  #       { name = "path"; }
  #       { name = "cmdline"; }
  #     ];
  #   };
  # };
    formatting = {
      fields = [ "kind" "abbr" "menu" ];
      format.__raw = ''function(entry, vim_item)
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
      end'';
    };
    snippet.expand.__raw = ''
      function(args)
        require('luasnip').lsp_expand(args.body)
      end
    '';
    window.documentation.border = [
      "┌"
      "─"
      "┐"
      "│"
      "┘"
      "─"
      "└"
      "│"
    ];
    sources = [
      {
        name = "nvim_lsp";
        # entry_filter = function(entry)
        #   return not (entry:get_kind() == require("cmp.types").lsp.CompletionItemKind.Snippet
        #     and entry.source:get_debug_name() == "nvim_lsp:emmet_ls")
        # end,
      }
      { name = "path"; }
      { name = "luasnip"; }
      { name = "omni"; }
      { name = "nvim_lsp_signature_help"; }
      { name = "crates"; }
      { name = "buffer"; }
      { name = "dotenv"; }
    ];
    # mapping = lib.mkIf cfg.complete {
    #   "<BS>".__raw = ''
    #     require("cmp").mapping(function(_fallback)
    #       local keys = cmp_utils.smart_bs()
    #       vim.api.nvim_feedkeys(keys, 'nt', true)
    #     end, { 'i', 's' })
    #   '';
    #   "<Tab>".__raw = ''
    #     require("cmp").mapping(function(_fallback)
    #       if require("cmp").visible() then
    #         -- If there is only one completion candidate, use it.
    #         if #require("cmp").get_entries() == 1 then
    #           require("cmp").confirm({ select = true })
    #         else
    #           require("cmp").select_next_item()
    #         end
    #       elseif require("luasnip").expand_or_locally_jumpable() then
    #         require("luasnip").expand_or_jump()
    #       elseif require("neogen").jumpable() then
    #         require("neogen").jump_next()
    #       elseif cmp_utils.in_whitespace() then
    #         cmp_utils.smart_tab()
    #       else
    #         require("cmp").complete()
    #         -- else
    #         -- require("cmp").mapping.select_next_item({ behavior = require("cmp.types").cmp.SelectBehavior.Insert })
    #         -- fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
    #       end
    #     end, { "i", "s" })
    #   '';
    #   "<S-Tab>".__raw = ''
    #     require("cmp").mapping(function(_fallback)
    #       if require("cmp").visible() then
    #         require("cmp").select_prev_item()
    #       elseif require("luasnip").jumpable(-1) and cmp_utils.in_snippet() then
    #         require("luasnip").jump(-1)
    #       elseif require("neogen").jumpable(true) then
    #         require("neogen").jump_prev()
    #       else
    #         -- require("cmp").mapping.select_prev_item({ behavior = require("cmp.types").cmp.SelectBehavior.Insert })
    #         require("cmp").complete()
    #       end
    #     end, { "i", "s" })
    #   '';
    #   "<C-Space>".__raw = ''require("cmp").mapping(require("cmp").mapping.complete(), { 'i', 'c' })'';
    #   "<CR>".__raw = ''
    #     require("cmp").mapping({
    #       i = require("cmp").mapping.confirm({ select = true }),
    #       c = require("cmp").mapping.confirm({ select = false }),
    #     })
    #   '';
    # };
}
