if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
" Themes
Plug 'arcticicestudio/nord-vim'
Plug 'mhartington/oceanic-next'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'ayu-theme/ayu-vim'
Plug 'morhetz/gruvbox'
" File Bash Search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" For programing
Plug 'pangloss/vim-javascript'    " JavaScript support
Plug 'leafgarland/typescript-vim' " TypeScript syntax
Plug 'neoclide/coc.nvim' , { 'branch' : 'release' }
" Nerd Tree (Left Bar Files)
Plug 'preservim/nerdtree'
" Status Bar Buttom
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
if has('nvim') || has('patch-8.0.902')
    Plug 'mhinz/vim-signify'
else
    Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
endif
Plug 'jmcantrell/vim-virtualenv'
" C#
Plug 'OmniSharp/omnisharp-vim'
Plug 'dense-analysis/ale'
" React Native
Plug 'ianks/vim-tsx'
call plug#end()

let g:signify_diff_relative_to = 'working_tree'
let g:airline#extensions#hunks#enabled = 1

let g:coc_global_extensions = [ 'coc-tsserver', 'coc-tslint-plugin', 'coc-emmet', 'coc-css', 'coc-html', 'coc-json', 'coc-prettier', 'coc-yank' ]
" HERE FOR KIDS COMING FROM YOUTUBE.
let g:ale_linters = {
            \ 'cs': ['OmniSharp'],
            \ 'javascript': ['flow-language-server']
            \}
let b:ale_linters = ['cs', 'flow-language-server']
let g:airline_powerline_fonts = 1

let g:OmniSharp_server_use_mono=1

autocmd FileType cs nmap <silent> <buffer> <leader>gd <Plug>(omnisharp_go_to_definition)
autocmd FileType cs nmap <silent> <buffer> <leader>rn <Plug>(omnisharp_rename)
autocmd FileType cs nmap <silent> <buffer> <leader>ff :OmniSharpCodeFormat<CR>
