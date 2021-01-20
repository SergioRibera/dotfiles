let mapleader = " "

nnoremap <leader>sv :source $MYVIMRC<CR>
" Vim's auto indentation feature does not work properly with text copied from outside of Vim. Press the <F2> key to toggle paste mode on/off.
nnoremap <F2> :set invpaste paste?<CR>
imap <F2> <C-O>:set invpaste paste?<CR>
set pastetoggle=<F2>

" Map the <Space> key to toggle a selected fold opened/closed.
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

" Shortcuts
noremap <leader>w :w<cr>
noremap <leader>gs :CocSearch
noremap <leader>fs :Files<cr>
noremap <leader><cr> <cr><c-w>h:q<cr>
noremap <leader>n :NERDTreeToggle<CR>
noremap <leader>ws :split<cr>
noremap <leader>wh :vsplit<cr>
" Vim Files
noremap <leader>cd :call VimFiles#CreateDir()<Cr>
noremap <leader>cf :call VimFiles#CreateFile()<Cr> 
noremap <leader>ce :call VimFiles#CreateDirThemplate()<Cr>
noremap <leader>cr :call VimFiles#CreateFileThemplate()<Cr>

" Shortcuts Buffetline
noremap <Tab> :bn<CR>
noremap <S-Tab> :bp<CR>
noremap <Leader><Tab> :Bw<CR>
noremap <Leader><S-Tab> :Bw!<CR>
noremap <C-t> :tabnew split<CR>

" Coc Navigation.
nnoremap <leader> K :call CocAction('doHover')<CR>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> <leader>y  :<C-u>CocList -A --normal yank<cr>
nnoremap <leader>gd :call CocAction('jumpDefinition', 'drop')<CR>
nmap <leader>rn <Plug>(coc-rename)
nmap <silent> <buffer> <leader>gd <Plug>(omnisharp_go_to_definition)
nmap <silent> <buffer> <leader>rn <Plug>(omnisharp_rename)
nmap <silent> <buffer> <leader>ff :OmniSharpCodeFormat<CR>
nmap <leader>do <Plug>(coc-codeaction)
" Move between tabs
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>
nnoremap <C-j> :tabprevious<CR>
nnoremap <C-k> :tabnext<CR>
" Toggle between transparent
" nnoremap <C-t> : call Toggle_transparent()<CR>
