noremap <leader>aa :call ccolor#SelectNord()<CR>
noremap <leader>ss :call ccolor#SelectOceanicNext()<CR>
noremap <leader>dd :call ccolor#SelectAyu()<CR>
noremap <leader>qq :call ccolor#SelectPalenight()<CR>
noremap <leader>ww :call ccolor#SelectGruvbox()<CR>

function! ccolor#SelectNord()
    colorscheme nord
    call s:RefreshHighlight()
endfunction
function! ccolor#SelectOceanicNext()
    colorscheme OceanicNext
    call s:RefreshHighlight()
endfunction
function! ccolor#SelectAyu()
    colorscheme ayu
    call s:RefreshHighlight()
endfunction
function! ccolor#SelectPalenight()
    colorscheme palenight
    call s:RefreshHighlight()
endfunction
function! ccolor#SelectGruvbox()
    colorscheme gruvbox
    call s:RefreshHighlight()
endfunction

function! s:RefreshHighlight()
    highlight! link NERDTreeFlags NERDTreeDir
endfunction

function! ccolor#ChangeColor()
    autocmd vimenter * hi Normal guibg=NONE ctermbg=NONE
    autocmd vimenter * hi EndOfBuffer guibg=NONE ctermbg=NONE
    autocmd ColorScheme * highlight Normal guibg=None ctermbg=None
    autocmd ColorScheme * highlight EndOfBuffer guibg=None ctermbg=None
    syntax on
endfunction

