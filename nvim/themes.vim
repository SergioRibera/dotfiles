" change colorscheme
"noremap <leader>aa :colorscheme nord<cr> :syntax on <CR> :call webdevicons#refresh() <CR>
"noremap <leader>ss :colorscheme OceanicNext<cr> :syntax on<CR> :call webdevicons#refresh() <CR>
"noremap <leader>dd :colorscheme ayu<cr> :syntax on <CR> :call webdevicons#refresh() <CR>
"noremap <leader>qq :colorscheme palenight<cr> :syntax on <CR> :call webdevicons#refresh() <CR>
"noremap <leader>ww :colorscheme gruvbox<cr> :syntax on <CR> :call webdevicons#refresh() <CR>

" Set Ayu Theme
set termguicolors
let ayucolor="mirage"

" Seleccion de tema de color
" colorscheme nord
"colorscheme OceanicNext
" colorscheme palenight
"colorscheme ayu

call ccolor#SelectOceanicNext()
call ccolor#ChangeColor()

if exists('+termguicolors')
    let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif

hi Pmenu ctermfg=NONE ctermbg=236 cterm=NONE guifg=NONE guibg=#32302f gui=NONE
hi PmenuSel ctermfg=NONE ctermbg=24 cterm=NONE guifg=NONE guibg=#427b58 gui=NONE
