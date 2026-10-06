""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Author: Gustavo Yokoyama Ribeiro <gyr AT protonmail DOT ch>
" File:   vim.vim
" Update: 20110502 23:57:04
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

call gyrlib#ProgTextMode()
setlocal foldmethod=marker

" }}}1
"===============================================================================
" Abbreviation:{{{1
iab <buffer> fh,, <C-R>=gyrlib#AddFh('"', 'short')<CR><C-R>=gyrlib#EatChar('\s')<CR>

"}}}1
"===============================================================================
" Mapping:{{{1
noremap <silent><buffer><Leader>u :call gyrlib#UpdateDate()<CR>

"}}}1
"===============================================================================

let &cpo = s:keep_cpo
unlet s:keep_cpo

" vim: set ft=vim ff=unix fdm=marker :
