""""""""""""""""""""""""""""""""""
"
" Author: Gustavo Yokoyama Ribeiro
" File:   perl.vim
" Update: 20120213
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

setlocal makeprg=perl\ -c\ %
setlocal errorformat+=%m\ at\ %f\ line\ %l%.%#
setlocal errorformat+=%m\ at\ %f\ line\ %l\.
setlocal errorformat+=%m\ at\ %f\ line\ %l
setlocal omnifunc=syntaxcomplete#Complete
setlocal foldmethod=syntax
setlocal matchpairs+==:;

setlocal omnifunc& omnifunc=syntaxcomplete#Complete
let perl_include_pod = 1
let perl_want_scope_in_variables = 1
let perl_extended_vars = 1
let perl_fold = 1
let perl_fold_blocks = 1
"let perl_string_as_statement = 1
"let perl_no_sync_on_sub = 1
"let perl_no_sync_on_global_var = 1

" http://search.cpan.org/dist/perl/pod/perlstyle.pod
" Indents are 4 spaces
setlocal shiftwidth=4
setlocal tabstop=4
setlocal softtabstop=4
" And they really are spaces, *not* tabs
setlocal expandtab

"-------------------------------------------------------------------------------
" Plugin:{{{2
"
" vim-lsp: {{{3
" perl lsp (sudo zypper install cpanminus; cpanm Perl::LanguageServer)
if executable('perl-language-server')
    " pip install python-lsp-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'perl-language-server',
        \ 'cmd': {server_info->['perl-language-server']},
        \ 'allowlist': ['perl'],
        \ })
endif
"
" ale: {{{3
let b:ale_linters = {
    \   'perl': ['perlcritic'],
    \ }
let b:ale_fixer = {
    \   'perl': ['perltidy'],
    \ }

" }}}1
"===============================================================================
" Mapping:{{{1
noremap <silent><buffer><Leader>mx :call gyrlib#MakeExecutable()<CR>
" check syntax
noremap <buffer><Leader>s :!perl -c -w %<CR>

"}}}1
"===============================================================================
" Abbreviation:{{{1
iab <buffer> fh,, <C-R>=gyrlib#AddFh('#', 'short')<CR><C-R>=gyrlib#EatChar('\s')<CR>

" }}}1
"===============================================================================

let &cpo = s:keep_cpo
unlet s:keep_cpo

if !exists('s:load_perl')
    finish
endif
let s:load_perl = 1

"===============================================================================
" Functions:{{{1

"}}}1
"===============================================================================

" vim: set filetype=vim fileformat=unix foldmethod=marker :
