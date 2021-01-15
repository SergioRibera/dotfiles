" Bottom Bar
let g:lightline = {
    \ 'colorscheme': 'ayu_mirage',
    \ 'active': {
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
    \   'readonly': 'LightlineReadonly'
    \ },
    \ 'component_type': {
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

"  nerdtree
let NERDTreeQuitOnOpen=1
let NERDTreeAutoDeleteBuffer=1
let NERDTreeMinimalUI=1
let NERDTreeDirArrows=1
let NERDTreeIgnore=['\.git$', '\.idea$', '\.vscode$', '\.history$', '\.meta$', '^node_modules$']


let g:signify_diff_relative_to = 'working_tree'
let g:airline#extensions#hunks#enabled = 1

" HTML, JSX
let g:closetag_filenames = '*.html,*.js,*.jsx,*.ts,*.tsx,*.xml,*.xaml'

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
let g:coc_global_extensions = [ 'coc-tsserver', 'coc-tslint-plugin', 'coc-emmet', 'coc-css', 'coc-html', 'coc-json', 'coc-prettier', 'coc-yank' ]
" HERE FOR KIDS COMING FROM YOUTUBE.
let g:ale_linters = {
            \ 'cs': ['OmniSharp'],
            \ 'javascript': ['flow-language-server']
            \}
let b:ale_linters = ['cs', 'flow-language-server']

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
