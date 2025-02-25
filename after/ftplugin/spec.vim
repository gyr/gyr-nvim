""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Author: Gustavo Yokoyama Ribeiro <gyr AT protonmail DOT ch>
" File:   spec.vim
" Update: 20100814 03:20:20
" (C) Copyright 2010 Gustavo Yokoyama Ribeiro
" Licensed under CreativeCommons Attribution-ShareAlike 3.0 Unsupported
" http://creativecommons.org/licenses/by-sa/3.0/ for more info.
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if &cp
    finish
endif
let s:keep_cpo = &cpo
set cpo&vim
"===============================================================================
" Settings:{{{1

"-------------------------------------------------------------------------------
" Plugin:{{{2
"
" ale: {{{3
let b:ale_linters = {
    \   'spec': ['rpmlint'],
    \ }

" }}}1
"===============================================================================
" Mapping:{{{1
nnoremap <buffer><Leader>r :call <SID>RpmBuild("<C-R>=expand("%:p")<CR>")<CR>

"}}}1
"===============================================================================
" Abbreviation:{{{1
cab <buffer> build,, !sudo rpmbuild -ba <C-R>=expand("%:p")<CR><C-R>=gyrlib#EatChar('\s')<CR>
cab <buffer> install,, !sudo rpm -i /usr/src/redhat/RPMS/i386/<C-R>=expand("%:t:r")<CR><C-R>=gyrlib#EatChar('\s')<CR>
cab <buffer> uninstall,, !sudo rpm -e <C-R>=expand("%:t:r")<CR><C-R>=gyrlib#EatChar('\s')<CR>

"}}}1
"===============================================================================
if !exists('s:load_spec')
    let s:load_spec = 1
endif

if s:load_spec
    "===============================================================================
    " Functions:{{{1
    function! s:RpmBuild(full_filename)
        if $STY == ""
            echo "screen is not running."
        else
            echo system("screen -p 1 -X stuff 'sudo rpmbuild -ba ".substitute(a:full_filename, "'", "'\\\\''", 'g')."\n'")
        endif
    endfunction

    "}}}1
    "===============================================================================
endif

let &cpo = s:keep_cpo
unlet s:keep_cpo

" vim: set ft=vim ff=unix fdm=marker :
