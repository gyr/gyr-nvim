""""""""""""""""""""""""""""""""""
"
" Author: Gustavo Yokoyama Ribeiro
" File:   xml.vim
" Update: 20100814 03:20:30
" (C) Copyright 2010 Gustavo Yokoyama Ribeiro
" Licensed under CreativeCommons Attribution-ShareAlike 3.0 Unsupported
" http://creativecommons.org/licenses/by-sa/3.0/ for more info.
"
""""""""""""""""""""""""""""""""""

if &cp
    finish
endif
let s:keep_cpo = &cpo
set cpo&vim
"===============================================================================
" Settings:{{{1

"setlocal omnifunc& omnifunc=xmlcomplete#CompleteTags

" Set the makeprg to use xmllint with the shellredirect option for error capture
set makeprg=xmllint\ --noout\ --shellredirect\ 1\ %
" Define the errorformat for xmllint's output
set errorformat=%f:%l:%c:%m

setlocal foldmethod=indent
setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal expandtab

"-------------------------------------------------------------------------------
" Plugin:{{{2
"
" ale: {{{3
let b:ale_linters = {
    \   'xml': ['xmllint'],
    \ }
let b:ale_fixers = {
    \   'xml': ['xmllint'],
    \ }

" }}}1
"===============================================================================
" Mapping:{{{1
" check syntax
noremap <buffer><Leader>s :!xmllint %<CR>

"}}}1
"===============================================================================
if !exists('s:load_xml')
    let s:load_xml = 1
endif

if s:load_xml
    "===============================================================================
    " Functions:{{{1

    "}}}1
    "===============================================================================
endif

let &cpo = s:keep_cpo
unlet s:keep_cpo

" vim: set ft=vim ff=unix fdm=marker :
