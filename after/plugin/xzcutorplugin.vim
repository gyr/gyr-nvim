""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Author: Gustavo Yokoyama Ribeiro <gyr AT protonmail DOT ch>
" File:  xzcutorplugin.vim
" Update: 20110906
" (C) Copyright 2011 Gustavo Yokoyama Ribeiro
" Licensed under CreativeCommons Attribution-ShareAlike 3.0 Unsupported
" http://creativecommons.org/licenses/by-sa/3.0/ for more info.
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Writing Vim Plugins: http://stevelosh.com/blog/2011/09/writing-vim-plugins/

if exists('g:load_xzcutorplugin') || &cp
    finish
endif
let g:load_xzcutorplugin = 1
let s:keep_cpo = &cpo
set cpo&vim

"===============================================================================
" Maps:{{{1

if !exists('g:xzcutorplugin_map_keys')
    let g:xzcutorplugin_map_keys = 1
endif

if !exists('g:xzcutorplugin_map_prefix')
    let g:xzcutorplugin_map_prefix = '<leader>'
endif

if g:xzcutorplugin_map_keys

    augroup XzcutorVim
        autocmd!
        autocmd FileType perl
                    \ execute "noremap <silent><buffer>" g:xzcutorplugin_map_prefix."xv :set lz<bar>call xzcutor#VimExecutor(\"<C-R>=expand(\"%:p\")<CR>\", \"perl \", \"\\n\")<bar>set nolz<CR>" |
                    \ execute "vnoremap <silent><buffer>" g:xzcutorplugin_map_prefix."xv \"ry :set lz<bar>call xzcutor#VimExecutor(@r, \"perl -e'\", \"'\")<bar>set nolz<CR>"
        autocmd FileType python
                    \ execute "noremap <silent><buffer>" g:xzcutorplugin_map_prefix."xv :set lz<bar>call xzcutor#VimExecutor(\"<C-R>=expand(\"%:p\")<CR>\", \"python \", \"\\n\")<bar>set nolz<CR>" |
                    \ execute "vnoremap <silent><buffer>" g:xzcutorplugin_map_prefix."xv \"ry :set lz<bar>call xzcutor#VimExecutor(@r, \"python <<EOF\\n\", \"\\nEOF\\n\")<bar>set nolz<CR>"
        autocmd FileType sh
                    \ execute "noremap <silent><buffer>" g:xzcutorplugin_map_prefix."xv :set lz<bar>call xzcutor#VimExecutor(\"<C-R>=expand(\"%:p\")<CR>\")<bar>set nolz<CR>" |
                    \ execute "vnoremap <silent><buffer>" g:xzcutorplugin_map_prefix."xv \"ry :set lz<bar>call xzcutor#VimExecutor(@r)<bar>set nolz<CR>"
    augroup END
    if $STY != ""
        augroup XzcutorScreen
            autocmd!
            autocmd FileType perl
                        \ execute "noremap <silent><buffer>" g:xzcutorplugin_map_prefix."xx :set lz<bar>call xzcutor#ScreenSetVars()<CR><bar>set nolz<CR>" |
                        \ execute "noremap <silent><buffer>" g:xzcutorplugin_map_prefix."xs :set lz<bar>call xzcutor#ScreenExecutor(\"<C-R>=expand(\"%:p\")<CR>\", \"perl \", \"\\n\")<bar>set nolz<CR>" |
                        \ execute "vnoremap <silent><buffer>" g:xzcutorplugin_map_prefix."xs \"ry :set lz<bar>call xzcutor#ScreenExecutor(@r, \"perl -e'\", \"'\\n\")<bar>set nolz<CR>"
            autocmd FileType python
                        \ execute "noremap <silent><buffer>" g:xzcutorplugin_map_prefix."xx :set lz<bar>call xzcutor#ScreenSetVars()<CR><bar>set nolz<CR>" |
                        \ execute "noremap <silent><buffer>" g:xzcutorplugin_map_prefix."xs :set lz<bar>call xzcutor#ScreenExecutor(\"<C-R>=expand(\"%:p\")<CR>\", \"python \", \"\\n\")<bar>set nolz<CR>" |
                        \ execute "vnoremap <silent><buffer>" g:xzcutorplugin_map_prefix."xs \"ry :set lz<bar>call xzcutor#ScreenExecutor(@r, \"python <<EOF\\n\", \"\\nEOF\\n\")<bar>set nolz<CR>"
            autocmd FileType sh
                        \ execute "noremap <silent><buffer>" g:xzcutorplugin_map_prefix."xx :set lz<bar>call xzcutor#ScreenSetVars()<CR><bar>set nolz<CR>" |
                        \ execute "noremap <silent><buffer>" g:xzcutorplugin_map_prefix."xs :set lz<bar>call xzcutor#ScreenExecutor(\"<C-R>=expand(\"%:p\")<CR>\\n\")<bar>set nolz<CR>" |
                        \ execute "vnoremap <silent><buffer>" g:xzcutorplugin_map_prefix."xs \"ry :set lz<bar>call xzcutor#ScreenExecutor(@r)<bar>set nolz<CR>"
        augroup END
    endif
endif

" }}}1
"===============================================================================

let &cpo = s:keep_cpo
unlet s:keep_cpo

" vim: set ft=vim ff=unix fdm=marker :
