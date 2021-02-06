" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')
Plug 'file://'.expand('~/Proyectos/Plugins/Vim/vim-general-conceal/')
Plug 'SergioRibera/vim-files', { 'branch': 'develop' }
Plug 'SergioRibera/vim-screenshot', { 'do': 'npm install --prefix Renderizer' }
" Themes
Plug 'arcticicestudio/nord-vim'
Plug 'mhartington/oceanic-next'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'ayu-theme/ayu-vim'
Plug 'morhetz/gruvbox'
Plug 'ghifarit53/tokyonight-vim'
" IDE
Plug 'dense-analysis/ale'
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/fzf', { 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'mhinz/vim-signify'
Plug 'yggdroot/indentline' " show identation
Plug 'scrooloose/nerdcommenter' " Advanced commenter
Plug 'turbio/bracey.vim', {'do': 'npm install --prefix server'} " live reload html
" For programing
Plug 'pangloss/vim-javascript'    " JavaScript support
Plug 'leafgarland/typescript-vim' " TypeScript syntax
Plug 'neoclide/coc.nvim' , { 'branch' : 'release' }
Plug 'OmniSharp/omnisharp-vim'
Plug 'ianks/vim-tsx'
" typing
Plug 'jiangmiao/auto-pairs'
Plug 'alvan/vim-closetag'
Plug 'tpope/vim-surround'
" Nerd Tree (Left Bar Files)
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'vwxyutarooo/nerdtree-devicons-syntax'
" Status Bar
Plug 'maximbaz/lightline-ale'
Plug 'itchyny/lightline.vim'
Plug 'josa42/vim-lightline-coc'
"Plug 'mengelbrecht/lightline-bufferline'
" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'sinetoami/lightline-hunks'
call plug#end()
