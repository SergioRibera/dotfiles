noremap <leader>aa :colorscheme nord<CR>
noremap <leader>ss :colorscheme OceanicNext<CR>
noremap <leader>dd :colorscheme ayu<CR>
noremap <leader>qq :colorscheme palenight<CR>
noremap <leader>ww :colorscheme gruvbox<CR>
noremap <leader>ee :colorscheme tokyonight<CR>
" Toggle Transparent Background
nnoremap <leader>tt :call ccolor#ChangeBGColor()<CR>

let t:is_transparent = 0
let t:groupBgColorsNvim = has('nvim') ? ['guibg'] : ['ctermbg']

function! s:automaticChange()
    if t:is_transparent == 0
        call ccolor#EnableTransparency()
    endif
endfunction
function! s:clearBg(hl)
    for group in t:groupBgColorsNvim
        execute 'highlight ' . a:hl . ' ' . group . '=NONE'
    endfor
endfunction
function! ccolor#DisableTransparency()
    let l:colors_name = get(g:, 'colors_name', '')
    echomsg l:colors_name
    if l:colors_name !=# ''
        try
            execute 'colorscheme ' . l:colors_name
        endtry
    endif
endfunction
function! ccolor#EnableTransparency()
    call s:clearBg('Normal')
    call s:clearBg('EndOfBuffer')
    call s:clearBg('LineNr')
    call s:clearBg('SignColumn')
    call s:clearBg('VertSplit')
    call s:clearBg('NonText')
endfunction

function! ccolor#ChangeBGColor()
    if t:is_transparent == 0
        call ccolor#EnableTransparency() | let t:is_transparent = 0 | syntax on
    else
        call ccolor#DisableTransparency() | let t:is_transparent = 1
    endif
endfunction

autocmd VimEnter * call ccolor#EnableTransparency()
autocmd ColorScheme * call s:automaticChange()
" Remove Nerd Tree Backets
augroup nerdtreeconcealbrackets
      autocmd!
      autocmd FileType nerdtree syntax match hideBracketsInNerdTree "\]" contained conceal containedin=ALL
      autocmd FileType nerdtree syntax match hideBracketsInNerdTree "\[" contained conceal containedin=ALL
      autocmd FileType nerdtree setlocal conceallevel=3
      autocmd FileType nerdtree setlocal concealcursor=nvic
augroup END
