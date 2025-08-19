{ cfg, colors, lib }: {
  options.component_separators.left = "";
  options.component_separators.right = "";
  options.section_separators = {
    # left = "";
    # right = "";
    left = "";
    right = "";
  };

  options.disabled_filetypes.statusline = [ "Term" ];
  options.disabled_filetypes.winbar = [ "Term" ];

  sections = {
    lualine_a = [
      {
        __unkeyed = "mode";
        upper = true;
      }
    ];
    lualine_b = [
      {
        __unkeyed = "branch";
        icon = "";
      }
    ];
    lualine_c = [
      {
        __unkeyed = "filetype";
        icon_only = true;
      }
      {
        __unkeyed = "filename";
        file_status = true;
        symbols = { modified = "•"; readonly = ""; };
      }
    ] ++ lib.lists.optionals cfg.complete [
      {
        __unkeyed = "diagnostics";
        sources = [ "nvim_diagnostic" ];
        symbols = { error = " "; warn = " "; info = " "; };
        color_error = colors.base08;
        color_warn = colors.base0E;
        color_info = colors.base05;
        on_click.__raw = ''function(n, b)
          if n ~= 1 then
            return
          end
          if b == 'l' or b == 'left' then
            require("telescope.builtin").diagnostics()
          end
        end'';
      }
    ];
    lualine_x = { __empty = {}; };
    lualine_y = lib.lists.optionals cfg.complete [ "lsp_status" ];
    lualine_z = [ "location" ];
  };

  inactive_sections = {
    lualine_c = [ "filetype" ];
    lualine_x = [ "location" ];
  };
}
