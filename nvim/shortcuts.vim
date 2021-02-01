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
noremap <leader>n :NERDTreeToggle<CR>
noremap <leader>ws :split<cr>
noremap <leader>wh :vsplit<cr>
" Vim Files
"
" Dirs
noremap <leader>cd :call VimFiles#DirCreate()<Cr>
noremap <leader>ce :call VimFiles#DirCreateFromTemplate()<Cr>
" Files
noremap <leader>cf :call VimFiles#FileCreate()<Cr>
noremap <leader>cv :call VimFiles#FileCreateVS()<Cr>
noremap <leader>ch :call VimFiles#FileCreateHS()<Cr>
noremap <leader>cw :call VimFiles#FileCreateCW()<Cr>
" Templates
noremap <leader>tc :call VimFiles#FileTemplateCreate()<Cr>
noremap <leader>tv :call VimFiles#FileTemplateCreateVS()<Cr>
noremap <leader>th :call VimFiles#FileTemplateCreateHS()<Cr>
noremap <leader>tw :call VimFiles#FileTemplateCreateCW()<Cr>
" Manipulate Rename Files
noremap <leader>rw :call VimFiles#ManipulateRenameCurrentFile()<Cr>
noremap <leader>rf :call VimFiles#ManipulateRenameFile()<Cr>
" Manipulate Move Files
noremap <leader>mw :call VimFiles#ManipulateMoveCurrentFile()<Cr>
noremap <leader>mf :call VimFiles#ManipulateMoveFile()<Cr>
" Manipulate Delete Files
noremap <leader>dw :call VimFiles#ManipulateDeleteCurrentFile()<Cr>
noremap <leader>df :call VimFiles#ManipulateDeleteFile()<Cr>


" Coc Navigation.
"nnoremap <leader> K :call CocAction('doHover')<CR>
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
nnoremap <C-j> :tabprevious<CR>
nnoremap <C-k> :tabnext<CR>
" Toggle between transparent
" nnoremap <C-t> : call Toggle_transparent()<CR>
