"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Author: Gustavo Yokoyama Ribeiro <gyr AT protonmail DOT ch>
" File:   gyrplugin.vim
" Update: 20110315 09:33:00
" (C) Copyright 2010 Gustavo Yokoyama Ribeiro
" Licensed under CreativeCommons Attribution-ShareAlike 3.0 Unsupported
" http://creativecommons.org/licenses/by-sa/3.0/ for more info.
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Writing Vim Plugins: http://stevelosh.com/blog/2011/09/writing-vim-plugins/

if exists('g:load_gyrplugin') || &cp
    finish
endif
let g:load_gyrplugin = 1
let s:keep_cpo = &cpo
set cpo&vim

"===============================================================================
" Initialization:{{{1
let s:NONE = ""
" Table of completions...
"                          Left   Right    Complete with...       Restore
"                          =====  =======  ====================   =======
call gyrlib#AddCompletion( '{',   s:NONE,  "}",                      1    )
"call AddCompletion(  '{',   '}',     "\<CR>\<C-D>\<ESC>O",     0    )
call gyrlib#AddCompletion( '{',   '}',     "\<CR>\<ESC>O",           0    )
call gyrlib#AddCompletion( '\[',  s:NONE,  "]",                      1    )
"call AddCompletion(  '\[',  '\]',    "\<CR>\<ESC>O\<TAB>",     0    )
call gyrlib#AddCompletion( '\[',  '\]',    "\<CR>\<C-D>\<ESC>O\<TAB>",     0    )
call gyrlib#AddCompletion( '(',   s:NONE,  ")",                      1    )
"call AddCompletion(  '(',   ')',     "\<CR>\<ESC>O\<TAB>",     0    )
call gyrlib#AddCompletion(  '(',   ')',     "\<CR>\<C-D>\<ESC>O\<TAB>",     0    )
call gyrlib#AddCompletion( '<',   s:NONE,  ">",                      1    )
call gyrlib#AddCompletion( '<',   '>',     "\<CR>\<ESC>O\<TAB>",     0    )
call gyrlib#AddCompletion( '"',   s:NONE,  '"',                      1    )
call gyrlib#AddCompletion( '"',   '"',     "\\n",                    1    )
call gyrlib#AddCompletion( "'",   s:NONE,  "'",                      1    )
call gyrlib#AddCompletion( "'",   "'",     s:NONE,                   0    )

" }}}1
"===============================================================================
" Maps:{{{1

if !exists('g:gyrplugin_map_keys')
    let g:gyrplugin_map_keys = 1
endif

if !exists('g:gyrplugin_map_prefix')
    let g:gyrplugin_map_prefix = '<leader>'
endif

if g:gyrplugin_map_keys
    "  GYRPLUGIN MAPS:{{{2
    "if !hasmapto('<Plug>GyrpluginShowAllChars')
    "    map <unique><Leader>es <Plug>GyrpluginShowAllChars
    "endif
    "noremap <silent><unique><script><Plug>GyrpluginShowAllChars
    "    \ :set lz<Bar>call <SID>ShowAllChars()<Bar>set nolz<CR>
    "noremap <silent><unique><Leader>ch :set lz<Bar>call <SID>ShowAllChars()<Bar>set nolz<CR>

    "}}}2
    " GYRLIB MAPS:{{{2
    execute "noremap <silent><unique>" g:gyrplugin_map_prefix."q" ":set lz<Bar>call gyrlib#BufcloseCloseIt()<Bar>set nolz<CR>"
    "noremap <silent><unique><Leader>c :set lz<Bar>call gyrlib#CommentOnOff()<Bar>set nolz<CR>
    execute "noremap <silent><unique>" g:gyrplugin_map_prefix."ss" ":set lz<Bar>call gyrlib#SaveCurrentSession()<Bar>set nolz<CR>"
    execute "noremap <silent><unique>" g:gyrplugin_map_prefix."f" ":set lz<Bar>call gyrlib#FindMate()<Bar>set nolz<CR>"
    "noremap <silent><unique><Leader>h :set lz<Bar>call gyrlib#ToggleShowEvilspace()<Bar>set nolz<CR>
    "execute "noremap <silent><unique>" g:gyrplugin_map_prefix."r" ":set lz<Bar>call gyrlib#RunShellCommand()<Bar>set nolz<CR>"

    inoremap <Tab> <C-R>=gyrlib#SmartComplete()<CR>

    onoremap an :<c-u>call gyrlib#NextTextObject('a', 'f')<cr>
    xnoremap an :<c-u>call gyrlib#NextTextObject('a', 'f')<cr>
    onoremap in :<c-u>call gyrlib#NextTextObject('i', 'f')<cr>
    xnoremap in :<c-u>call gyrlib#NextTextObject('i', 'f')<cr>

    onoremap al :<c-u>call gyrlib#NextTextObject('a', 'F')<cr>
    xnoremap al :<c-u>call gyrlib#NextTextObject('a', 'F')<cr>
    onoremap il :<c-u>call gyrlib#NextTextObject('i', 'F')<cr>
    xnoremap il :<c-u>call gyrlib#NextTextObject('i', 'F')<cr>

    xnoremap * :<C-u>call gyrlib#VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
    xnoremap # :<C-u>call gyrlib#VSetSearch('?')<CR>?<C-R>=@/<CR><CR>

    "nnoremap <unique><leader><Space> :MRU <C-z><S-Tab>
    nnoremap <unique><leader>d2u :set lz<Bar>call gyrlib#DosToUnix()<Bar>set nolz<CR>

    "cab eu MRU <C-z><S-Tab>
    "
    " unset search highlight
    "nnoremap <silent><Leader>/ :let @/=""<CR>  :echo 'Highlights Cleared'<CR>
    nnoremap <BS> <Esc>:nohlsearch<Bar>echo 'Highlights Cleared'<CR>

    nnoremap <silent><unique><Leader><BS> :set lz<Bar>call gyrlib#DelTrailingSpaces()<Bar>set nolz<CR>

    nnoremap <silent><unique><Leader><Del> :call gyrlib#ToggleTextMode()<CR>

endif

"}}}2

" }}}1
"===============================================================================
" Highlight:{{{1
"highlight Evilspace      ctermbg=darkred
"highlight TrailingSpaces ctermbg=white
"highlight TrailingSpaces cterm=reverse
"highlight TabChar        ctermbg=darkred
"highlight EvilTab        cterm=reverse
highlight Evilspace      cterm=underline ctermfg=darkred
highlight TrailingSpaces cterm=underline ctermfg=darkgreen
highlight TabChar        cterm=underline ctermfg=darkyellow
"highlight OverLength     cterm=underline
"highlight EvilTab        cterm=underline ctermfg=darkgreen
"highlight OverLength     ctermbg=darkgray ctermfg=white

" }}}1
"===============================================================================
" Autocmd:{{{1
"autocmd! CursorMoved,CursorMovedI * call <SID>HiBrace()
autocmd! BufWinEnter,WinEnter * call <SID>ShowAllChars()

" }}}1
"===============================================================================
" Functions:{{{1
"-------------------------------------------------------------------------------
" ShowAllChars:{{{2
" http://vim.wikia.com/wiki/VimTip1274
" http://vim.wikia.com/wiki/Highlight_unwanted_spaces
function! s:ShowAllChars()
    " Trailing whitespaces
    let l:trailing_spaces = '\s\+$'
    " Spaces before tab
    "let l:evil_spaces = ' \+\ze\t'
    " Tab
    let l:tab_char = '\t\+'
    "let l:over_length = '/\%81v.*/'
    "let l:over_length = '/\%81v.\+/'
    let l:over_length = '/\%81v./'
    " Tab before or after space
    "let l:evil_tab = '/\( \t\|\t \)/'
    syntax clear Evilspace
    exec 'syntax match TrailingSpaces "'.l:trailing_spaces.'" containedin=ALL'
    exec 'syntax match TabChar "'.l:tab_char.'" containedin=ALL'
    "exec 'match OverLength '.l:over_length
    "exec 'match EvilTab '.l:evil_tab
    "exec 'syntax match OverLength '.l:over_length.'" containedin=ALL'
    "exec 'syntax match EvilTab '.l:evil_tab.'" containedin=ALL'
endfunction

" }}}2
"-------------------------------------------------------------------------------
" [DISABLE]HiBrace:{{{2
"function! s:HiBrace()
"    let c_lnum = line('.')
"    let c_col = col('.')
"    let c = getline(c_lnum)[c_col -1]
"    if match(c,'{') == '0' || match(c,'}') == 0
"        set cursorcolumn
"    else
"        set nocursorcolumn
"    endif
"endfunction

" }}}2
"-------------------------------------------------------------------------------

" }}}1
"===============================================================================

"===============================================================================
" Command:{{{1
command! -nargs=0 -bar Qargs execute 'args' gyrlib#QuickfixFilenames()
command! -nargs=1 -complete=customlist,gyrlib#ListRecentFiles MRU call gyrlib#MRU("edit", <f-args>)

" }}}1
"===============================================================================

let &cpo = s:keep_cpo
unlet s:keep_cpo

" vim: set ft=vim ff=unix fdm=marker :
