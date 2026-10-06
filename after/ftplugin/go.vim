""""""""""""""""""""""""""""""""""
"
" Author: Gustavo Yokoyama Ribeiro
" File:   go.vim
" Update: 20250521 17:00:23
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

call gyrlib#ProgTextMode()

" Set the makeprg to use golint with the parsable output format
setlocal makeprg=golangci-lint\ run\ --show-stats=false\ %
" Define the errorformat for golint's output
setlocal errorformat=%f:%l:%c:\ %m

setlocal foldmethod=indent
setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal expandtab

"-------------------------------------------------------------------------------
" Plugin:{{{2
"

" }}}1
"===============================================================================
" Mapping:{{{1

"}}}1
"===============================================================================
if !exists('s:load_go')
    let s:load_go = 1
endif

if s:load_go
    "===============================================================================
    " Functions:{{{1

    "}}}1
    "===============================================================================
endif

let &cpo = s:keep_cpo
unlet s:keep_cpo

" vim: set ft=vim ff=unix fdm=marker :
