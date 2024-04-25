{ lib, guiEnable }: {
  completeopt = "menu,menuone,noselect";
  guifont = lib.optionalString guiEnable "FiraCode_Nerd_Font,CaskaydiaCove_Nerd_Font:h13";
  number = true;
  # cul = true;
  signcolumn = "yes";
  relativenumber = true;
  hidden = true;
  ignorecase = true;
  splitbelow = true;
  splitright = true;
  termguicolors = true;
  numberwidth = 1;
  mouse = lib.optionalString guiEnable "a";
  cmdheight = 1;
  updatetime = 250; # update interval for gitsigns
  clipboard = "unnamedplus";
  modelines = 0;
  formatoptions = "tcqrn1";
  autoindent = true;
  smartindent = true;
  # guicursor = "n-i:blinkon250";
  scrolloff = 1;
  backspace = "indent,eol,start";
  ttyfast = true;
  showmode = true;
  showcmd = true;
  laststatus = 2;
  encoding = "utf-8";
  hlsearch = true;
  incsearch = true;
  smartcase = true;

  expandtab = true;
  shiftwidth = 4;
}
