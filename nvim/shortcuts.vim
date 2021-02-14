"
"             ──────────────────────────────────
"            |                                   |
"            |         Key Shortcuts             |
"            |                                   |
"             ──────────────────────────────────
"
"

let mapleader = " "

nnoremap <leader>sv :source $MYVIMRC<CR>

" Shortcuts
noremap <leader>w :w<cr>
noremap <leader>wq :wq<cr>
noremap <leader>q :q<cr>
"noremap <leader>fs :Files<cr>
noremap <leader>fs <cmd>Telescope find_files color=all<Cr>
noremap <leader>n :NERDTreeToggle<CR>
noremap <leader>ws :split<cr>
noremap <leader>wh :vsplit<cr>

augroup coc_commands
    autocmd!
    autocmd CursorHold *.cs OmniSharpTypeLookup
    " Coc Navigation.
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)
    nnoremap <leader>gd :call CocAction('jumpDefinition', 'drop')<CR>
    nmap <leader>rn <Plug>(coc-rename)
    nmap <silent> <buffer> <leader>gd <Plug>(omnisharp_go_to_definition)
    nmap <leader>do <Plug>(coc-codeaction)

    " The following commands are contextual, based on the cursor position.
    autocmd FileType cs nmap <silent> <buffer> <Leader>fu <Plug>(omnisharp_find_usages)
    autocmd FileType cs nmap <silent> <buffer> <Leader>fi <Plug>(omnisharp_find_implementations)
    autocmd FileType cs nmap <silent> <buffer> <Leader>pd <Plug>(omnisharp_preview_definition)
    autocmd FileType cs nmap <silent> <buffer> <Leader>pi <Plug>(omnisharp_preview_implementations)
    autocmd FileType cs nmap <silent> <buffer> <Leader>fsy <Plug>(omnisharp_find_symbol)
    autocmd FileType cs nmap <silent> <buffer> <Leader>fx <Plug>(omnisharp_fix_usings)

    " Find all code errors/warnings for the current solution and populate the quickfix window
    autocmd FileType cs nmap <silent> <buffer> <Leader>osgc <Plug>(omnisharp_global_code_check)
    " Contextual code actions (uses fzf, vim-clap, CtrlP or unite.vim selector when available)
    autocmd FileType cs nmap <silent> <buffer> <Leader>osa <Plug>(omnisharp_code_actions)
    autocmd FileType cs nmap <silent> <buffer> <Leader>osf <Plug>(omnisharp_code_format)

    autocmd FileType cs nmap <silent> <buffer> <Leader>osrn <Plug>(omnisharp_rename)
    autocmd FileType cs nmap <silent> <buffer> <Leader>osre <Plug>(omnisharp_restart_server)
augroup END

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

"
"   ScreenShot
"
noremap <leader>ps :TakeScreenShot<Cr>

" Move between tabs
nnoremap <C-j> :tabprevious<CR>
nnoremap <C-k> :tabnext<CR>
