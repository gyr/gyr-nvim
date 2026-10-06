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
" Abbreviation:{{{1
cab <buffer> build,, !sudo rpmbuild -ba <C-R>=expand("%:p")<CR><C-R>=gyrlib#EatChar('\s')<CR>
cab <buffer> uninstall,, !sudo rpm -e <C-R>=expand("%:t:r")<CR><C-R>=gyrlib#EatChar('\s')<CR>

"}}}1
"===============================================================================

let &cpo = s:keep_cpo
unlet s:keep_cpo

" vim: set ft=vim ff=unix fdm=marker :
