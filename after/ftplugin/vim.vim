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
"" include vim tags
setlocal tags+=,~/.vim-tmp/tags/vimtags
"" regenerate tags
"call system("ctags -R -f ~/.vim/tags/vimtags ~/.vim/bundle/")

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
if !exists('s:load_vim')
    let s:load_vim = 1
endif

if s:load_vim
    "===============================================================================
    " Functions:{{{1
    "function! s:UpdateDate()
    "    if getline(5) =~ "\" Update: "
    "        silent exec "5s/\" Update: .*/\" Update: " . strftime("%Y%m%d %H:%M:%S") . "/"
    "        normal! ``
    "    endif
    "endfunction

    "}}}1
    "===============================================================================
endif

let &cpo = s:keep_cpo
unlet s:keep_cpo

" vim: set ft=vim ff=unix fdm=marker :
