" Set compatibility to Vim only.
set nocompatible
set nolist
set rnu
" Helps force plug-ins to load correctly when it is turned back on below.
filetype off

" Set cursor
set guicursor=n-v-c:line

" Turn on syntax highlighting.
syntax on

" For plug-ins to load correctly.
filetype plugin indent on

" Turn off modelines
set modelines=0

" Vim's auto indentation feature does not work properly with text copied from outside of Vim. Press the <F2> key to toggle paste mode on/off.
nnoremap <F2> :set invpaste paste?<CR>
imap <F2> <C-O>:set invpaste paste?<CR>
set pastetoggle=<F2>

" Uncomment below to set the max textwidth. Use a value corresponding to the width of your screen.
set textwidth=79
set formatoptions=tcqrn1
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent
set smartindent
"set noshiftround

" Display 5 lines above/below the cursor when scrolling with a mouse.
set scrolloff=5
" Fixes common backspace problems
set backspace=indent,eol,start

" Speed up scrolling in Vim
set ttyfast

" Status bar
set laststatus=2

" Display options
set showmode
set showcmd

" Highlight matching pairs of brackets. Use the '%' character to jump between them.
set matchpairs+=<:>

" Show line numbers
set number

" Set status line display
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ [BUFFER=%n]\ %{strftime('%c')}

" Encoding
set encoding=utf-8

" Highlight matching search patterns
set hlsearch
" Enable incremental search
set incsearch
" Include matching uppercase words with lowercase search term
set ignorecase
" Include only uppercase words with uppercase search term
set smartcase

" Store info from no more than 100 files at a time, 9999 lines of text, 100kb of data. Useful for copying large amounts of data between files.
set viminfo='100,<9999,s100

" Map the <Space> key to toggle a selected fold opened/closed.
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

" Automatically save and load folds
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview"
let mapleader = " "
noremap <leader>w :w<cr>
noremap <leader>gs :CocSearch
noremap <leader>fs :Files<cr>
noremap <leader><cr> <cr><c-w>h:q<cr>

" change colorscheme
noremap <leader>aa :colorscheme nord<cr> :syntax on <CR>
noremap <leader>ss :colorscheme OceanicNext<cr> :syntax on <CR>
noremap <leader>dd :colorscheme ayu<cr> :syntax on <CR>
noremap <leader>qq :colorscheme palenight<cr> :syntax on <CR>
noremap <leader>ww :colorscheme gruvbox<cr> :syntax on <CR>

noremap <leader>n :NERDTreeToggle<CR>
noremap <leader>ws :split<cr>
noremap <leader>wh :vsplit<cr>

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')
" File Bash Search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" For programing
Plug 'pangloss/vim-javascript'    " JavaScript support
Plug 'leafgarland/typescript-vim' " TypeScript syntax
Plug 'neoclide/coc.nvim' , { 'branch' : 'release' }
" Nerd Tree (Left Bar Files)
Plug 'preservim/nerdtree'

Plug 'vim-airline/vim-airline'
" C#
Plug 'OmniSharp/omnisharp-vim'
Plug 'dense-analysis/ale'
" React Native
Plug 'ianks/vim-tsx'
" Temas
Plug 'arcticicestudio/nord-vim'
Plug 'mhartington/oceanic-next'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'ayu-theme/ayu-vim'
Plug 'morhetz/gruvbox'
call plug#end()

" Set Ayu Theme
set termguicolors
let ayucolor="mirage"

" == AUTOCMD ================================
" by default .ts file are not identified as typescript and .tsx files are not
" identified as typescript react file, so add following
au BufNewFile,BufRead *.ts setlocal filetype=typescript
au BufNewFile,BufRead *.tsx setlocal filetype=typescript.tsx
" == AUTOCMD END ================================

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

hi Pmenu ctermfg=NONE ctermbg=236 cterm=NONE guifg=NONE guibg=#32302f gui=NONE
hi PmenuSel ctermfg=NONE ctermbg=24 cterm=NONE guifg=NONE guibg=#427b58 gui=NONE

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nnoremap <leader>gd :call CocAction('jumpDefinition', 'drop')<CR>
nmap <leader>rn <Plug>(coc-rename)
autocmd FileType typescript,typescriptreact command! -nargs=0 Prettier :CocCommand prettier.formatFile
nnoremap <silent> <leader>y  :<C-u>CocList -A --normal yank<cr>

" Auto close
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

" Move between tabs
nnoremap <C-Left> :tabprevious<CR>                                                                            
nnoremap <C-Right> :tabnext<CR>
nnoremap <C-j> :tabprevious<CR>                                                                            
nnoremap <C-k> :tabnext<CR>


" Seleccion de tema de color
" colorscheme nord
" colorscheme OceanicNext
colorscheme palenight

:imap ii <Esc>
