""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Author: Gustavo Yokoyama Ribeiro <gyr AT protonmail DOT ch>
" File: suse.vim
" Update: 20181010
" (C) Copyright 2018 Gustavo Yokoyama Ribeiro
" Licensed under CreativeCommons Attribution-ShareAlike 3.0 Unsupported
" http://creativecommons.org/licenses/by-sa/3.0/ for more info.
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if exists('g:SUSELoadSettings') || &cp
    finish
endif
let g:SUSELoadSettings = 1
let s:keep_cpo = &cpo
set cpo&vim

"===============================================================================
" Settings:{{{1
set path+=$HOME/.gyr.d/suse.d/**

" Plugin:{{{2

" Vimwiki: {{{3
if isdirectory($HOME."/.vim/pack/vendor/start/vimwiki")
    let suse_wiki = {}
    let suse_wiki.path = '~/.gyr.d/suse.d/vimwiki/'
    let suse_wiki.path_html = '~/.gyr.d/suse.d/public_html/'
    let suse_wiki.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'sh': 'sh', 'perl': 'perl', 'conf': 'conf', 'fstab': 'fstab', 'deb': 'debsources', 'resolv': 'resolv', 'xml': 'xml'}
    let suse_list = [suse_wiki]
    let g:vimwiki_list = g:vimwiki_list + suse_list
endif

" }}}1
"===============================================================================
" Autocmd:{{{1
augroup Suse
    autocmd BufNewFile,BufRead,BufEnter *.dat set filetype=conf
augroup END

" }}}1
"===============================================================================
" Mapping:{{{1
"nnoremap <unique><Leader>ei :edit $HOME/.gyr.d/suse.d/**/*

" }}}1
"===============================================================================
" Abbreviations:{{{1
"-------------------------------------------------------------------------------
" Insert Mode: {{{2
iab oscvc,, -------------------------------------------------------------------<CR><C-R>=strftime("%a %b %d %H:%M:%S UTC %Y")<cr> - Gustavo Yokoyama Ribeiro <gyribeiro@suse.com><C-R>=gyrlib#EatChar('\s')<CR><CR><CR>
"}}}2
"-------------------------------------------------------------------------------
" Plugins: {{{2
" FZF: {{{3
if isdirectory($HOME."/.config/nvim/pack/vendor/start/fzf.vim")
    cab es,, Files $HOME/.gyr.d/suse.d/<CR>
else
    cab es,, edit $HOME/.gyr.d/suse.d/**/*<C-R>=gyrlib#EatChar('\s')<CR>
endif
"}}}2
"-------------------------------------------------------------------------------

" }}}1
"===============================================================================

let &cpo = s:keep_cpo
unlet s:keep_cpo

" vim: set ft=vim ff=unix fdm=marker :
