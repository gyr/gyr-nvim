""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Author: Gustavo Yokoyama Ribeiro <gyr AT protonmail DOT ch>
" File:   sh.vim
" Update: 20110502 23:56:46
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

"setlocal makeprg=sh\ -n\ %
"setlocal errorformat=%f:\ %l:\ %m
setlocal makeprg=shellcheck\ -f\ gcc\ %

call gyrlib#ProgTextMode()

"-------------------------------------------------------------------------------
" Plugin:{{{2
"
" ale: {{{3
let b:ale_linters = {
    \   'sh': ['shellcheck', 'bashate'],
    \ }
let b:ale_fixers = {
    \   'sh': ['shfmt'],
    \ }
let g:ale_sh_shellcheck_options = '-e SC2162'
let g:ale_sh_bashate_options = '-i E006'

"}}}1
"===============================================================================
" Autocommand:{{{1
"au BufWritePre <buffer> call <SID>UpdateDate()

" Code static analysis
"au BufWritePost * :silent make | redraw!

"au QuickFixCmdPost [^l]* nested cwindow
"au QuickFixCmdPost    l* nested lwindow

"}}}1
"===============================================================================
" Abbreviation:{{{1
"iab <buffer> bash,, #!/bin/bash<C-R>=gyrlib#EatChar('\s')<CR>
"iab <buffer> sb,, #!/bin/sh<C-R>=gyrlib#EatChar('\s')<CR>
iab <buffer> fh,, <C-R>=gyrlib#AddFh('#', 'full')<CR><C-R>=gyrlib#EatChar('\s')<CR>
iab <buffer> gh,, [ $# -eq 1 -a "$1" = '--help' ] && { gyr-print-helper "$0"; exit 0; }<C-R>=gyrlib#EatChar('\s')<CR>
iab <buffer> ge,, { gyr-print -e "${0##*/}" ""; exit 1; }<C-R>=gyrlib#EatChar('\s')<CR>
iab <buffer> error,, # Always exit on errors<CR>
            \set -e<CR>
            \# Undefined variables, we don't like you<CR>
            \set -u<CR>
            \# ERR traps are inherited by shell functions, command substitutions and<CR>
            \# commands executed in a subshell environment.<CR>
            \set -E<CR>
            \<C-R>=gyrlib#EatChar('\s')<CR>
iab <buffer> trap,, # trap handler<CR>
            \trap 'exit_hook $?' EXIT<CR>
            \# reset exit code<CR>
            \#trap 'exit_hook $?; trap - EXIT' EXIT INT TERM HUP QUIT<CR>
            \# ignore exit code<CR>
            \#trap 'trap "" EXIT; exit_hook $?' EXIT INT TERM HUP QUIT<CR>
            \exit_hook() {<CR>
            \if [ "$1" -ne "0" ]; then<CR>
            \gyr-print -e "${0##*/}" "Error at line ${LINENO} with exit code $1"<CR>
            \echo "cmd: '${BASH_COMMAND}'"<CR>
            \fi<CR>
            \}<CR>
            \<C-R>=gyrlib#EatChar('\s')<CR>
iab <buffer> quiet,, > /dev/null 2>&1<C-R>=gyrlib#EatChar('\s')<CR>

"}}}1
"===============================================================================
" Mapping:{{{1
noremap <silent><buffer><Leader>mx :call gyrlib#MakeExecutable()<CR>
"noremap <buffer><Leader>e :py EvalCurRange()<CR>
" check syntax
noremap <buffer><Leader>s :!sh -n %<CR>
noremap <silent><buffer><Leader>u :call gyrlib#UpdateDate()<CR>

"}}}1
"===============================================================================
if !exists('s:load_sh')
    let s:load_sh = 1
endif

if s:load_sh
    "===============================================================================
    " Functions:{{{1
    "function! s:UpdateDate()
    "    if getline(6) =~ "# Update: "
    "        silent exec "6s/# Update: .*/# Update: " . strftime("%Y%m%d %H:%M:%S") . "/"
    "        normal ``
    "    endif
    "endfunction

    "}}}1
    "===============================================================================
endif

"python << EOL
"import vim
"import os
"def EvalCurRange():
"    os.system('\n'.join(vim.current.range))
"EOL

let &cpo = s:keep_cpo
unlet s:keep_cpo

" vim: set ft=vim ff=unix fdm=marker :
