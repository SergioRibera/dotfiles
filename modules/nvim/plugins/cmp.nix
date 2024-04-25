{ cfg, lib }: {
  enable = true;
  cmdline = {
    "/" = {
      sources = [
        { name = "buffer"; }
      ];
    };
    ":" = {
      sources = [
        { name = "path"; }
        { name = "cmdline"; }
      ];
    };
  };
  settings = {
    formatting = {
      fields = [ "kind" "abbr" "menu" ];
    };
    snippet.expand = ''
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
    mapping = lib.mkIf cfg.complete {
      "<BS>" = ''
        cmp.mapping(function(_fallback)
          local keys = smart_bs()
          vim.api.nvim_feedkeys(keys, 'nt', true)
        end, { 'i', 's' })
      '';
      "<Tab>" = ''
        cmp.mapping(function(_fallback)
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
        end, { "i", "s" })
      '';
      "<S-Tab>" = ''
        cmp.mapping(function(_fallback)
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
        end, { "i", "s" })
      '';
      "<C-Space>" = "cmp.mapping(cmp.mapping.complete(), { 'i', 'c' })";
      "<CR>" = ''
        cmp.mapping({
          i = cmp.mapping.confirm({ select = true }),
          c = cmp.mapping.confirm({ select = false }),
        })
      '';
    };
  };
}
