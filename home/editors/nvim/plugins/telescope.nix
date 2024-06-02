{ cfg, lib }: {
  defaults = {
    vimgrep_arguments = [
      "rg"
      "--color=never"
      "--no-heading"
      "--with-filename"
      "--line-number"
      "--column"
      "--smart-case"
    ];
    prompt_prefix = "❯ ";
    selection_caret = "❯ ";
    entry_prefix = "  ";
    initial_mode = "insert";
    selection_strategy = "reset";
    sorting_strategy = "descending";
    layout_strategy = "horizontal";
    layout_config = {
      horizontal.mirror = false;
      vertical.mirror = false;
    };
    # file_sorter =  require"telescope.sorters".get_fuzzy_file
    file_ignore_patterns = [ "^target/" "***/target/" "^node_modules/" ];
    # generic_sorter =  require"telescope.sorters".get_generic_fuzzy_sorter
    borderchars = [ "─" "│" "─" "│" "╭" "╮" "╯" "╰" ];
    color_devicons = true;
    use_less = true;
    path_display = { };
    set_env = { COLORTERM = "truecolor"; }; # default = nil
    # file_previewer = require"telescope.previewers".vim_buffer_cat.new
    # grep_previewer = require"telescope.previewers".vim_buffer_vimgrep.new
    # qflist_previewer = require"telescope.previewers".vim_buffer_qflist.new

    # Developer configurations: Not meant for general override
    # buffer_previewer_maker = require"telescope.previewers".buffer_previewer_maker
  };
  extensions = {
    ui-select.enable = true;
    media-files = lib.mkIf cfg.complete {
      enable = true;
      settings.filetypes = [ "png" "jpg" "webm" ];
    };
    file-browser = {
      enable = true;
      settings = {
        depth = 0;
        hijack_netrw = true;
        select_buffer = true;
        collapse_dirs = true;
        hide_parent_dir = true;
        mappings = {
          i = {
            "<C-a>" = "require('telescope._extensions.file_browser.actions').create";
            "<C-i>" = "require('telescope._extensions.file_browser.actions').create_from_prompt";
            "<C-r>" = "require('telescope._extensions.file_browser.actions').rename";
            "<C-m>" = "require('telescope._extensions.file_browser.actions').move";
            "<C-c>" = "require('telescope._extensions.file_browser.actions').copy";
            "<C-d>" = "require('telescope._extensions.file_browser.actions').remove";
            "<C-o>" = "require('telescope._extensions.file_browser.actions').open";
            "<C-t>" = "require('telescope.actions').select_tab";
            "<bs>" = "require('telescope._extensions.file_browser.actions').backspace";
          };
          n = {
            "a" = "require('telescope._extensions.file_browser.actions').create";
            "r" = "require('telescope._extensions.file_browser.actions').rename";
            "m" = "require('telescope._extensions.file_browser.actions').move";
            "c" = "require('telescope._extensions.file_browser.actions').copy";
            "d" = "require('telescope._extensions.file_browser.actions').remove";
            "o" = "require('telescope._extensions.file_browser.actions').open";
            "h" = "require('telescope._extensions.file_browser.actions').goto_home_dir";
            "t" = "require('telescope.actions').select_tab";
          };
        };
      };
    };
  };
}
