{ cfg, colors, lib }: {
  options.component_separators.left = "";
  options.component_separators.right = "";
  options.section_separators = {
    left = "";
    right = "";
  };

  options.disabled_filetypes.statusline = [ "Term" ];
  options.disabled_filetypes.winbar = [ "Term" ];

  sections = {
    lualine_a = [
      {
        name = "mode";
        upper = true;
      }
    ];
    lualine_b = [
      {
        name = "branch";
        icon = "";
      }
    ];
    lualine_c = [
      {
        name = "filetype";
        icon_only = true;
      }
      {
        name = "filename";
        file_status = true;
        symbols = { modified = "•"; readonly = ""; };
      }
    ] ++ lib.lists.optionals cfg.complete [
      {
        name = "diagnostics";
        sources = [ "nvim_diagnostic" ];
        symbols = { error = " "; warn = " "; info = " "; };
        color_error = colors.base08;
        color_warn = colors.base0E;
        color_info = colors.base05;
        on_click.__raw = ''
          function(n, b)
            if n ~= 1 then
              return
            end
            if b == 'l' or b == 'left' then
              vim.cmd(":Trouble<Cr>")
            end
          end
        '';
      }
    ];
    lualine_x = [ { name = ""; } ];
    lualine_y = lib.lists.optionals cfg.complete [
      {
        fmt.__raw = ''
          function()
              return require("lsp-progress").progress()
          end
        '';
      }
    ];
    lualine_z = [ "location" ];
  };

  inactive_sections = {
    lualine_c = [ "filetype" ];
    lualine_x = [ "location" ];
  };
}
