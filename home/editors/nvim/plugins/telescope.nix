{ }: let
  git_cwd = ''vim.fn.fnamemodify(vim.fn.finddir(".git", ".;"), ":h") or vim.fn.getcwd()'';
  vimgrep = [
      "rg"
      "--vimgrep"
      "--color=never"
      "--no-heading"
      "--with-filename"
      "--line-number"
      "--column"
      "--smart-case"
      "--hidden"
      "--no-binary"
      "--no-require-git"
      "--glob" "!.git/*"
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
      live_grep.cwd.__raw = git_cwd;
      find_files = {
        cwd.__raw = git_cwd;
        find_command = vimgrep ++ [ "--files" ];
      };
    };
  };

  extensions = {
    live-grep-args.enable = true;
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
