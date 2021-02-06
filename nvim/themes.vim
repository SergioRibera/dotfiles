" Set Ayu Theme
set termguicolors
let ayucolor="mirage"

" set theme tokyonight
let g:tokyonight_style = 'storm' " available: night, storm

" Init with OceanicNext Theme
call ccolor#SelectTokyoNight()
call ccolor#ChangeColor()

if exists('+termguicolors')
    let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif

hi Pmenu ctermfg=NONE ctermbg=236 cterm=NONE guifg=NONE guibg=#32302f gui=NONE
hi PmenuSel ctermfg=NONE ctermbg=24 cterm=NONE guifg=NONE guibg=#427b58 gui=NONE
