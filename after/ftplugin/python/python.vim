""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Author: Gustavo Yokoyama Ribeiro <gyr AT protonmail DOT ch>
" File:   python.vim
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

" Allow make to get syntax errors
" allows us to run :make and get syntax errors for our python scripts
" :cn :cp :cl :cw :cope :ccl
setlocal makeprg=pylint\ --reports=n\ --output-format=parseable\ %:p
setlocal errorformat=%f:%l:\ [%t%n%m

setlocal foldmethod& foldmethod=indent
" Indentation sets
setlocal smartindent
setlocal cinwords& cinwords=if,elif,else,for,while,try,except,finally,def,class

" make python follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
" Indents are 4 spaces
setlocal shiftwidth=4
setlocal tabstop=4
setlocal softtabstop=4
" And they really are spaces, *not* tabs
setlocal expandtab
setlocal textwidth=79

" include python tags
setlocal tags+=~/.vim-tmp/tags/python27tags

"}}}1
"===============================================================================
" Mapping:{{{1
noremap <buffer><Leader>mx :call gyrlib#MakeExecutable()<CR>

" }}}1
"===============================================================================
" Abbreviation:{{{1
iab <buffer> fh,, <C-R>=gyrlib#AddFh('#', 'short')<CR><C-R>=gyrlib#EatChar('\s')<CR>
cab <buffer> ctags,, !ctags -R -f ~/.vim-tmp/tags/python.ctags /usr/lib/python2.5/

" }}}1
"===============================================================================

let &cpo = s:keep_cpo
unlet s:keep_cpo

" vim: set filetype=vim fileformat=unix foldmethod=marker :
