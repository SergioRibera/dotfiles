{ cfg, colors, lib }: {
  enable = true;

  componentSeparators.left = "";
  componentSeparators.right = "";
  sectionSeparators = {
    left = "";
    right = "";
  };

  disabledFiletypes.statusline = [ "Term" ];
  disabledFiletypes.winbar = [ "Term" ];

  sections = {
    lualine_a = {
      mode.upper = true;
    };
    lualine_b = {
      branch.icon = "";
      # I not need more this
      # diff = lib.mkIf cfg.complete {
      #   extraConfig = {
      #     symbols = { added = " "; modified = "柳"; removed = " "; };
      #     color_added = colors.base0B;
      #     color_modified = colors.base03;
      #     color_removed = colors.base08;
      #   };
      # };
    };
    lualine_c = {
      diagnostics = lib.mkIf cfg.complete {
        name = "diagnostics";
        extraConfig = {
          sources = [ "nvim_diagnostic" ];
          symbols = { error = " "; warn = " "; info = " "; };
          color_error = colors.base08;
          color_warn = colors.base0E;
          color_info = colors.base05;
          on_click = ''
            function(n, b)
                if n ~= 1 then
                    return
                end
                if b == 'l' or b == 'left' then
                    vim.cmd(":Trouble<Cr>")
                end
            end
          '';
        };
      };
      filename = {
        name = "filename";
        icons_enabled = true;
        file_status = true;
        symbols = { modified = "•"; readonly = ""; };
      };
    };
    # TODO: add lsp-progress as plugin https://github.com/linrongbin16/lsp-progress.nvim
    lualine_y = lib.lists.optional cfg.complete [
      ''
        function() -- Setup lsp-progress component
            return require("lsp-progress").progress({
                max_size = 80,
            })
        end
      ''
    ];
    lualine_z = [
      "progress"
      "location"
    ];
  };

  inactive_sections = {
    lualine_c = [ "filetype" ];
    lualine_x = [ "location" ];
  };
}
