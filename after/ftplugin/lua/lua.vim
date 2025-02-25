""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Author: Gustavo Yokoyama Ribeiro <gyr AT protonmail DOT ch>
" File:   lua.vim
" Update: 20120213
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

setlocal foldmethod& foldmethod=indent
" Indentation sets
setlocal smartindent

" Indents are 4 spaces
setlocal shiftwidth=4
setlocal tabstop=4
setlocal softtabstop=4
" And they really are spaces, *not* tabs
setlocal expandtab
setlocal textwidth=79


"-------------------------------------------------------------------------------
" Plugin:{{{2
"
" vim-lsp: {{{3
" lua lsp (requires lua-language-server
if executable('lua-language-server')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'lua-language-server',
        \ 'cmd': {server_info->['lua-language-server']},
        \ 'allowlist': ['lua'],
        \ })
endif

" ale: {{{3
let b:ale_linters = {
    \   'lua': ['luacheck'],
    \ }
let b:ale_fixers = {
    \   'lua': ['stylua'],
    \ }
let g:ale_lua_luacheck_options = '--no-max-line-length'

"}}}2
"-------------------------------------------------------------------------------

"}}}1
"===============================================================================
" Autocommand:{{{1

" }}}1
"===============================================================================
" Tag Path:{{{1

"}}}1
"===============================================================================
" Mapping:{{{1
noremap <buffer><Leader>mx :call gyrlib#MakeExecutable()<CR>

" }}}1
"===============================================================================
" Abbreviation:{{{1
iab <buffer> fh,, <C-R>=gyrlib#AddFh('#', 'short')<CR><C-R>=gyrlib#EatChar('\s')<CR>

" }}}1
"===============================================================================

let &cpo = s:keep_cpo
unlet s:keep_cpo

if exists('s:load_lua')
    finish
endif
let s:load_lua = 1

"===============================================================================
" Function:{{{1

"}}}1
"===============================================================================

" vim: set filetype=vim fileformat=unix foldmethod=marker :
