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
Plug 'ryanoasis/vim-devicons'
Plug 'vwxyutarooo/nerdtree-devicons-syntax'
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

let NERDTreeIgnore=['\.git$', '\.idea$', '\.vscode$', '\.history$', '\.meta$', '^node_modules$']

let g:signify_diff_relative_to = 'working_tree'
let g:airline#extensions#hunks#enabled = 1

" Vim DevIcons
set conceallevel=3
let g:webdevicons_enable = 1
let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_enable_airline_tabline = 1
let g:webdevicons_enable_airline_statusline = 1
let g:webdevicons_conceal_nerdtree_brackets = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1
let g:WebDevIconsNerdTreeBeforeGlyphPadding = ''

" Coc
let g:coc_global_extensions = [ 'coc-tsserver', 'coc-tslint-plugin', 'coc-emmet', 'coc-css', 'coc-html', 'coc-json', 'coc-prettier', 'coc-yank', 'coc-deno' ]
" HERE FOR KIDS COMING FROM YOUTUBE.
let g:ale_linters = {
            \ 'cs': ['OmniSharp'],
            \ 'javascript': ['flow-language-server']
            \}
let b:ale_linters = ['cs', 'flow-language-server']
let g:airline_powerline_fonts = 1

let g:OmniSharp_popup = 1
let g:OmniSharp_server_use_mono=1
let g:FrameworkPathOverride='/lib/mono/4.7.2-api'

set completeopt=menuone,noinsert,noselect,popuphidden
set completepopup=highlight:Pmenu,border:off

" Asyncomplete: {{{
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 0
" }}}
" OmniSharp: {{{
let g:OmniSharp_popup_position = 'peek'
if has('nvim')
    let g:OmniSharp_popup_options = {
    \ 'winhl': 'Normal:NormalFloat'
    \}
else
    let g:OmniSharp_popup_options = {
    \ 'highlight': 'Normal',
    \ 'padding': [0, 0, 0, 0],
    \ 'border': [1]
    \}
endif
let g:OmniSharp_popup_mappings = {
    \ 'sigNext': '<C-n>',
    \ 'sigPrev': '<C-p>',
    \ 'pageDown': ['<C-f>', '<PageDown>'],
    \ 'pageUp': ['<C-b>', '<PageUp>']
    \}

nmap <silent> <buffer> <leader>gd <Plug>(omnisharp_go_to_definition)
nmap <silent> <buffer> <leader>rn <Plug>(omnisharp_rename)
nmap <silent> <buffer> <leader>ff :OmniSharpCodeFormat<CR>
nmap <silent> gr <Plug>(coc-references))
