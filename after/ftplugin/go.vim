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
" ale: {{{3
let b:ale_linters = {
    \   'go': ['golangci-lint'],
    \ }
" Set golangci-lint specific options
" This tells ALE to check the entire Go package, not just the current file.
" This is generally recommended for golangci-lint to work correctly with type checking.
let g:ale_go_golangci_lint_package = 1
" You can pass additional options to golangci-lint if needed
" For example, to use a specific config file (default is .golangci.yml)
" let g:ale_go_golangci_lint_options = '--config=/path/to/.golangci.yml'
" Or to enable/disable specific linters
" let g:ale_go_golangci_lint_options = '--enable=goimports,unparam --disable=errcheck'

" Set up gofmt as a fixer for Go files
let b:ale_fixers = {
    \   'go': ['gofmt'],
    \}

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
