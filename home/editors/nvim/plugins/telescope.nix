{ }: let
  git_cwd = ''vim.fn.fnamemodify(vim.fn.finddir(".git", ".;"), ":h") or vim.fn.getcwd()'';
  vimgrep = [
      "rg"
      "--color=never"
      "--no-heading"
      "--with-filename"
      "--line-number"
      "--column"
      "--smart-case"
      "--hidden"
      "--glob" "!**/.git/*" "--glob" "!**/target/*" "--glob" "!**/node_modules/*"
    ];
in {
  settings = {
    defaults = {
      prompt_prefix = "❯ ";
      selection_caret = "❯ ";
      history.limit = 5;
      sorting_strategy = "descending";
      layout_strategy = "horizontal"; # ideally dynamic
      layout_config = {
        horizontal.mirror = false;
        vertical.mirror = false;
      };
      set_env = { COLORTERM = "truecolor"; }; # default = nil
      vimgrep_arguments = vimgrep;
    };

    pickers = {
      live_grep = {
        cwd.__raw = git_cwd;
      };
      find_files = {
        cwd.__raw = git_cwd;
        hidden = true;
        no_ignore = false;
        no_ignore_parent = false;
        find_command = vimgrep ++ [ "--files" ];
      };
    };
  };

  extensions = {
    live-grep-args.enable = true;
    file-browser = {
      enable = true;
      settings.mappings.i = {
        "<C-a>" = "require('telescope._extensions.file_browser.actions').create";
        "<C-p>" = "require('telescope._extensions.file_browser.actions').create_from_prompt";
        "<C-r>" = "require('telescope._extensions.file_browser.actions').rename";
        "<C-m>" = "require('telescope._extensions.file_browser.actions').move";
        "<C-y>" = "require('telescope._extensions.file_browser.actions').copy";
        "<C-d>" = "require('telescope._extensions.file_browser.actions').remove";
        "<C-o>" = "require('telescope._extensions.file_browser.actions').open";
        "<C-g>" = "require('telescope._extensions.file_browser.actions').goto_parent_dir";
        "<C-e>" = "require('telescope._extensions.file_browser.actions').goto_home_dir";
        "<C-w>" = "require('telescope._extensions.file_browser.actions').goto_cwd";
        "<C-t>" = "require('telescope._extensions.file_browser.actions').change_cwd";
        "<C-s>" = "require('telescope._extensions.file_browser.actions').select_horizontal";
        "<C-v>" = "require('telescope._extensions.file_browser.actions').select_vertical";
        "<bs>" = "require('telescope._extensions.file_browser.actions').backspace";
      };
      settings.mappings.n = {
        "a" = "require('telescope._extensions.file_browser.actions').create";
        "r" = "require('telescope._extensions.file_browser.actions').rename";
        "m" = "require('telescope._extensions.file_browser.actions').move";
        "y" = "require('telescope._extensions.file_browser.actions').copy";
        "d" = "require('telescope._extensions.file_browser.actions').remove";
        "o" = "require('telescope._extensions.file_browser.actions').open";
        "g" = "require('telescope._extensions.file_browser.actions').goto_parent_dir";
        "e" = "require('telescope._extensions.file_browser.actions').goto_home_dir";
        "w" = "require('telescope._extensions.file_browser.actions').goto_cwd";
        "t" = "require('telescope._extensions.file_browser.actions').change_cwd";

        "s" = "require('telescope._extensions.file_browser.actions').select_horizontal";
        "v" = "require('telescope._extensions.file_browser.actions').select_vertical";
      };
    };
    ui-select = {
      enable = true;
      settings = {
        theme = "dropdown";
        layout_strategy = "center";
        layout_config = {
          preview_cutoff = 1;
          width.__raw = ''function(_, max_columns, _)
            return math.min(max_columns, 80)
          end'';
          height.__raw = ''function(_, _, max_lines)
            return math.min(max_lines, 15)
          end'';
        };
      };
    };
    project = {
      enable = true;
      settings = {
        base_dirs = [
          "/etc/nixos"
          "~/Public/rustlanges"
          "~/Public/rust"
          "~/Public/contributions"
          "~/Public/work"
          { __unkeyed = "~/Public/tutorials"; max_depth = 2; }
        ];
        theme = "dropdown";
        search_by = [ "title" "path" ];
        on_project_selected.__raw = ''function(prompt_bufnr)
          require("telescope._extensions.project.actions").change_working_directory(prompt_bufnr, false)
        end'';
      };
    };
  };
}
