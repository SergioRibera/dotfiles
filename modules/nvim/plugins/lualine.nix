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
      # I not need more this
      # diff = lib.mkIf cfg.complete {
      #   extraConfig = {
      #     symbols = { added = " "; modified = "柳"; removed = " "; };
      #     color_added = colors.base0B;
      #     color_modified = colors.base03;
      #     color_removed = colors.base08;
      #   };
      # };
    ];
    lualine_c = [
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
    # TODO: fix this
    # lualine_y = lib.lists.optionals cfg.complete [
    #   {
    #     __raw = ''
    #       function() -- Setup lsp-progress component
    #           return require("lsp-progress").progress({
    #               max_size = 80,
    #           })
    #       end
    #     '';
    #   }
    # ];
    lualine_z = [ "progress" "location" ];
  };

  inactiveSections = {
    lualine_c = [ "filetype" ];
    lualine_x = [ "location" ];
  };
}
