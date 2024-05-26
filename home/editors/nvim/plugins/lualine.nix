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
    lualine_a = [
      {
        name = "mode";
        extraConfig.upper = true;
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
        extraConfig.icon_only = true;
      }
      {
        name = "filename";
        extraConfig = {
          fileStatus = true;
          symbols = { modified = "•"; readonly = ""; };
        };
      }
    ] ++ lib.lists.optionals cfg.complete [
      {
        name = "diagnostics";
        extraConfig = {
          sources = [ "nvim_diagnostic" ];
          symbols = { error = " "; warn = " "; info = " "; };
          color_error = colors.base08;
          color_warn = colors.base0E;
          color_info = colors.base05;
          on_click = {
            __raw = ''
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
      }
    ];
    lualine_x = [ { name = ""; } ];
    lualine_y = lib.lists.optionals cfg.complete [
      {
        fmt = ''
          function()
              return require("lsp-progress").progress()
          end
        '';
      }
    ];
    lualine_z = [ "location" ];
  };

  inactiveSections = {
    lualine_c = [ "filetype" ];
    lualine_x = [ "location" ];
  };
}
