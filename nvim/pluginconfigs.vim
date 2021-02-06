" Vim Files
let g:vimFilesThemplatesDir = {
    \ 'react-native': 'react/native.txt',
    \}
let g:vimFilesThemplatesFiles = {
    \ 'react-component': 'react/react-component.jsx',
    \ 'cs-class': 'c-sharp/class.cs',
    \ 'cs-class-namespace': 'c-sharp/classnamespace.cs',
    \ 'cs-behaviour': 'c-sharp/behaviour.cs',
    \ 'cs-program': 'c-sharp/program.cs',
    \ 'cs-enum': 'c-sharp/enum.cs',
    \ 'cs-interface': 'c-sharp/interface.cs',
    \ 'html-empty': 'web/html/empty.html'
    \}

" Bottom Bar
let g:lightline = {
    \ 'colorscheme': 'ayu_mirage',
    \ 'active': {
    \   'tabline': 0,
    \   'left': [['mode', 'paste'], ['gitbranch'], ['linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok'], ['readonly', 'filename', 'modified']],
    \   'right': [['coc_status'], ['filetype', 'percent', 'lineinfo'], ['signify']]
    \ },
    \ 'inactive': {
    \   'left': [['inactive'], ['gitbranch'], ['relativepath'], ['signify']],
    \   'right': [['bufnum']]
    \ },
    \ 'component': {
    \   'bufnum': '%n',
    \   'inactive': 'inactive'
    \ },
    \ 'component_expand': {
    \   'linter_checking': 'lightline#ale#checking',
    \   'linter_infos': 'lightline#ale#infos',
    \   'linter_warnings': 'lightline#ale#warnings',
    \   'linter_errors': 'lightline#ale#errors',
    \   'linter_ok': 'lightline#ale#ok',
    \   'linter_hints': 'lightline#coc#hints',
    \   'status': 'lightline#coc#status',
    \ },
    \ 'component_function': {
    \   'gitbranch': 'lightline#hunks#composer',
    \   'readonly': 'LightlineReadonly',
    \   'filetype': 'MyFiletype',
    \   'filename': 'MyFileName',
    \ },
    \ 'component_type': {
    \   'buffers': 'tabsel',
    \   'linter_warnings': 'warning',
    \   'linter_errors': 'error',
    \   'linter_info': 'info',
    \   'linter_hints': 'hints',
    \   'linter_ok': 'left', 
    \ },
    \ 'subseparator': {
    \   'left': '',
    \   'right': ''
    \ }
    \}
" Lightline settings
autocmd BufWritePost,TextChanged,TextChangedI * call lightline#update()
let g:lightline#hunks#hunk_symbols = [ '+', '~', '-' ]
let g:lightline#hunks#only_branch = 1
let g:lightline#hunks#exclude_filetypes = [ 'startify', 'nerdtree', 'vista_kind', 'tagbar'  ]
let g:lightline#ale#indicator_checking = "\uf110"
let g:lightline#ale#indicator_infos = "~"
let g:lightline#ale#indicator_warnings = ""
let g:lightline#ale#indicator_errors = ""
let g:lightline#ale#indicator_ok = ""
function! LightlineReadonly()
    return &readonly && &filetype !=# 'help' ? '' : ''
endfunction
function! MyFiletype()
    return strlen(&filetype) ? WebDevIconsGetFileTypeSymbol().' '.&filetype : 'no ft'
endfunction
function! MyFileName()
    return WebDevIconsGetFileTypeSymbol().' '.expand('%:t')
endfunction

"  nerdtree
let NERDTreeQuitOnOpen=1
let NERDTreeAutoDeleteBuffer=1
let NERDTreeMinimalUI=1
let NERDTreeDirArrows=1
let NERDTreeIgnore=['\.git$', '\.idea$', '\.vscode$', '\.history$', '\.meta$', '^node_modules$']
let NERDTreeNodeDelimiter = "\x07"


let g:signify_diff_relative_to = 'working_tree'
let g:airline#extensions#hunks#enabled = 1

" HTML, JSX
let g:closetag_filenames = '*.html,*.js,*.jsx,*.ts,*.tsx,*.xml,*.xaml'

" Vim DevIcons
let g:webdevicons_enable = 1
let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_conceal_nerdtree_brackets = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = v:true
let g:DevIconsEnableFoldersOpenClose = 1
let g:WebDevIconsNerdTreeBeforeGlyphPadding = ""

" Coc
let g:coc_global_extensions = [ 'coc-tsserver', 'coc-tslint-plugin', 'coc-emmet', 'coc-css', 'coc-html', 'coc-json', 'coc-prettier', 'coc-yank' ]
" HERE FOR KIDS COMING FROM YOUTUBE.
let g:ale_linters = {
            \ 'cs': ['OmniSharp'],
            \ 'javascript': ['flow-language-server']
            \}
let b:ale_linters = ['cs', 'flow-language-server']

" Omnisharp

let g:OmniSharp_popup = 1
let g:OmniSharp_server_use_mono = 1
let g:OmniSharp_selector_findusages = 'fzf'

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
function! ShowDocIfNoDiagnostic(timer_id)
    if (coc#float#has_float() == 0)
        silent call CocActionAsync('doHover')
    endif
endfunction

"
" Screenshot
"
let g:vimShotSavePath = '~/Imágenes/Code'
let g:vimShotTimeOut = 1000

" vim fugitive
command! -bang -nargs=? -complete=dir GFiles
            \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=* Ag
            \ call fzf#vim#ag(<q-args>, fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=? -complete=dir Files
            \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=1

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" fugitive always vertical diffing
set diffopt+=vertical
