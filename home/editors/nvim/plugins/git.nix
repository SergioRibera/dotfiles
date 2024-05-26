{
  enable = true;
  settings = {
    signs = {
        add = {
            hl = "GitSignsAdd";
            text = "┃";
            numhl = "GitSignsAddNr";
            linehl = "GitSignsAddLn";
        };
        change = {
            hl = "GitSignsChange";
            text = "┃";
            numhl = "GitSignsChangeNr";
            linehl = "GitSignsChangeLn";
        };
        delete = {
            hl = "GitSignsDelete";
            text = "契";
            numhl = "GitSignsDeleteNr";
            linehl = "GitSignsDeleteLn";
        };
        topdelete = {
            hl = "GitSignsDelete";
            text = "契";
            numhl = "GitSignsDeleteNr";
            linehl = "GitSignsDeleteLn";
        };
        changedelete = {
            hl = "GitSignsChange";
            text = "┃";
            numhl = "GitSignsChangeNr";
            linehl = "GitSignsChangeLn";
        };
    };
    numhl = true;
    attach_to_untracked = false;
    current_line_blame = true;
    update_debounce = 200;
    diff_opts.algorithm = "minimal";
  };
}
