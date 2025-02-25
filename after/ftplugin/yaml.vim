""""""""""""""""""""""""""""""""""
"
" Author: Gustavo Yokoyama Ribeiro
" File:   yaml.vim
" Update: 20241204 11:02:40
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

setlocal omnifunc& omnifunc=yamlcomplete#CompleteTags

" Set the makeprg to use yamllint with the parsable output format
setlocal makeprg=yamllint\ --format\ parsable\ %
" Define the errorformat for yamllint's output
setlocal errorformat=%f:%l:%c:\ %m

setlocal foldmethod=indent
setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal expandtab

"-------------------------------------------------------------------------------
" Plugin:{{{2
"
" ale: {{{3
let b:ale_linters = {
    \   'yaml': ['yamllint'],
    \ }

" }}}1
"===============================================================================
" Mapping:{{{1
" check syntax
noremap <buffer><Leader>s :!yamllint %<CR>

"}}}1
"===============================================================================
if !exists('s:load_yaml')
    let s:load_yaml = 1
endif

if s:load_yaml
    "===============================================================================
    " Functions:{{{1

    "}}}1
    "===============================================================================
endif

let &cpo = s:keep_cpo
unlet s:keep_cpo

" vim: set ft=vim ff=unix fdm=marker :
