""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Author: Gustavo Yokoyama Ribeiro <gyr AT protonmail DOT ch>
" File:  .vimrc
" Update: 20120309
" (C) Copyright 2012 Gustavo Yokoyama Ribeiro
" Licensed under CreativeCommons Attribution-ShareAlike 3.0 Unsupported
" http://creativecommons.org/licenses/by-sa/3.0/ for more info.
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"===============================================================================
" Pre-Settings:{{{1
" first the disabled features due to security concerns
set modelines=0               " no modelines [http://www.guninski.com/vim1.html]
let g:secure_modelines_verbose=0 " securemodelines vimscript
let g:secure_modelines_modelines = 15 " 15 available modelines

let s:base_dir = $HOME."/.nvim-tmp"
let s:list_dir = ["/tags", "/backup", "/swap", "/aux-files", "/undo", "/sessions"]
for s:dir in s:list_dir
    call gyrlib#EnsureDirExists(s:base_dir.s:dir)
endfor

" Pack plugin
call gyrlib#EnsureDirExists($HOME."/.config/nvim/pack/vendor/start")

let g:netrw_home = s:base_dir
let g:netrw_winsize=10

filetype plugin indent off
syntax off
" Enable filetype detection
" Enable filetype-specific plugins
" Enable filetype-specific indenting
filetype plugin indent on

"}}}1
"===============================================================================
" Settings:{{{1
"""""""""""""""""""""""""""""""""""""""""""""""""
"                S E T I N G S                  "
"""""""""""""""""""""""""""""""""""""""""""""""""
" to see all options => :options
"-------------------------------------------------------------------------------
" Important:{{{2
set nocompatible    " Modo "No compatible" . Valores padrao para algumas opcoes sao adequados ao Vim, nao Vi.
set cpoptions+=$J
"set pastetoggle=<Insert>

"}}}2
"-------------------------------------------------------------------------------
" Moving around, searching and patterns:{{{2
set whichwrap+=<,>,[,]
set path=.
set path+=$HOME
set path+=$HOME/.gyr.d/**
set path+=$HOME/.config/nvim/**
set path+=**        " Search down into subfolders
                    " Provides tab-completion for all file-related tasks
set incsearch       " Search while typing
set magic           " Use magic patterns  (extended regular expressions) in search patterns
set ignorecase      " Ignore case on search
set smartcase       " Consider noic when search has upper case

"}}}2
"-------------------------------------------------------------------------------
" Tags:{{{2
set tags+=$HOME/.nvim-tmp/tags/kop.tags
set showfulltag     " Show more information while completing tags

"}}}2
"-------------------------------------------------------------------------------
" Displaying text:{{{2
set scrolloff=5     " Keep 3 lines below/above the cursor
set wrap            " Desliga quebra de linhas. As linhas vao ficar longas, ultrapassando a margem direita.
set linebreak nolist   " When wrap is on break lines at 'breakat', do not add <EOL>. list must be off. The linebreak setting will not work when the list setting is enabled.
if has("multi_byte")
    set showbreak=↪\      " String to put at the start of lines that have been wrapped (wrap must be on). number must be off.
    set fillchars+=diff:↔,vert:│
    set listchars+=tab:▸▸,trail:▪,eol:¬,extends:»,precedes:«,nbsp:ø,space:·
else
    set showbreak=>     " String to put at the start of lines that have been wrapped (wrap must be on). number must be off.
    set fillchars+=diff:-,vert:|
    set listchars+=tab:>-,trail:_,eol:$,extends:>,precedes:<,nbsp:%,space:.
endif
set sidescroll=5    " Keep 5 columns left/right the cursor
set sidescrolloff=10
set display+=lastline
set cmdheight=2     " 2 line for command
"set lazyredraw      " don't redraw when don't have to
set number        " Display line numbers
set numberwidth=1   " Use 1 col + 1 space for numbers

"}}}2
"-------------------------------------------------------------------------------
" Syntax, highlighting and spelling:{{{2
if &t_Co > 2 || has("gui_running")
    syntax enable
    set hlsearch         " Highligh search
    set background=dark " Use colors which look better on the background
    set synmaxcol=2000   " Syntax coloring lines that are too long just slows down the world
    let c_comment_strings=1 "highlighting strings inside C comments.
endif
set nocursorcolumn
set cursorline
if exists('+colorcolumn')
    set colorcolumn=+1
endif
set spelllang=en

"}}}2
"-------------------------------------------------------------------------------
" Cursor:{{{2
" Use a line cursor within insert mode and a block cursor everywhere else.
"
" Reference chart of values:
"   Ps = 0  -> blinking block.
"   Ps = 1  -> blinking block (default).
"   Ps = 2  -> steady block.
"   Ps = 3  -> blinking underline.
"   Ps = 4  -> steady underline.
"   Ps = 5  -> blinking bar (xterm).
"   Ps = 6  -> steady bar (xterm).
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
"}}}2
"-------------------------------------------------------------------------------
" Multiple windows:{{{2
set laststatus=2    " Sempre exibe a barra de status
if has('statusline')
    set statusline=
    set statusline+=[%n]      " buffer number
    try
        set statusline+=%{fugitive#statusline()}
    catch
    endtry
    set statusline+=\ %<%f\   " path to the file, as typed or relative to
                                 " current directory
    set statusline+=%m       " modified flag
    set statusline+=%r       " readonly flag
    set statusline+=%h       " help buffer flag
    set statusline+=%w       " preview window flag
    set statusline+=%=       " left/right separator
    try
        set statusline+=%#warningmsg#
        set statusline+=%*
    catch
    endtry
    try
        set statusline+=\|%{gyrlib#LinterStatus()}
    catch
    endtry
    set statusline+=\|%{&ff} " file format
    set statusline+=\|%{strlen(&fenc)?&fenc:'none'} " file enconding
    set statusline+=\|%Y      " file type
    set statusline+=\|%c%V:    " cursor column-virtual column number
    set statusline+=%l/%L    " cursor line/total lines
    set statusline+=\|%P     " percent through file
endif
set equalalways      " do not resize windows to the same size
set hidden           " allow editing multiple unsaved buffers
set splitbelow
set splitright
set switchbuf=useopen,usetab

"}}}2
"-------------------------------------------------------------------------------
" Terminal:{{{2
if match($TERM, "screen") != -1
    set term=xterm
    let g:GNU_Screen_used = 1
else
    let g:GNU_Screen_used = 0
endif
set ttyfast         " Send more characters to terminal, improving windows redraw
set title           " Display the file name on status bar
set titlestring=%t%(\ [%R%M]%)

"}}}2
"-------------------------------------------------------------------------------
" Using the mouse:{{{2
"set mousehide

"}}}2
"-------------------------------------------------------------------------------
" Messages and info:{{{2
set showcmd         " Display the command on status bar
set showmode        " Display the input mode on status bar
set ruler           " Display the cursor position on status bar
set report=0        " Warning when lines change
set confirm         " Confirm operation
set noerrorbells    " don't make noise
set novisualbell

"}}}2
"-------------------------------------------------------------------------------
" Selecting text:{{{2
" --copying / pasting
" allow vim commands to copy to system clipboard (*)
" for X11:
"   + is the clipboard register (Ctrl-{c,v})
"   * is the selection register (middle click, Shift-Insert)
""set clipboard+=unnamed " "unnamed" to use the * register like unnamed register
set clipboard-=autoselect " "unnamed" to use the * register like unnamed register
" use clipboard register in linux when supported
if has("unix") && v:version >= 703
    ""set clipboard+=unnamedplus
    "set clipboard^=unnamedplus
endif
" Prevent vim from trying to connect and use X server's clipboard,
" which caused a startup delay of about 14 seconds.
"[NEOVIM] set clipboard+=exclude:.*

"}}}2
"-------------------------------------------------------------------------------
" Editing text:{{{2
set undolevels=5000 " Undo level
if exists('+undoreload')
    set undoreload=10000
endif
set backspace=indent,eol,start " <BACKSpace> works on indentantion, line break and the start of insert
set formatoptions+=tn "list of flags that tell how automatic formatting works
set complete=.,w,b,u,U,t " do not scan include files
set dictionary=/usr/share/dict/words " more words!
set infercase       " in insert mode and ignorecase on the case of the match is adjusted depending on the typed text
set showmatch       " Show matchs
set matchtime=2     " For .2 seconds
set matchpairs+=<:>
set nojoinspaces    " on join lines, after a '.', '?' and '!' add only one space

"}}}2
"-------------------------------------------------------------------------------
" Tabs and indenting:{{{2
" Para converter tab em espaco usar o comando [:retab]
set tabstop=4       " <Tab> width
set shiftwidth=4    " Autoindent width
set smarttab
set softtabstop=4   " <BACKSpace> in an indentantion delete 4 characters
set shiftround      " indent using multiple of shiftwidth for > and <
set expandtab       " Replace <Tab> to <Space>
set autoindent
"set smartindent   "Disable due to cindent
set cindent
set cinoptions+=l1,t0,i0,(0

"}}}2
"-------------------------------------------------------------------------------
" Folding:{{{2
set foldopen+=hor,insert,jump,mark,percent,quickfix,search,tag,undo " add this stuff to open folder as well
set foldmethod=syntax " fold on syntax automatically, always
" http://dhruvasagar.com/2013/03/28/vim-better-foldtext
function! NeatFoldText()
  let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
  let lines_count = v:foldend - v:foldstart + 1
  let lines_count_text = '| ' . printf("%10s", lines_count . ' lines') . ' |'
  let foldchar = matchstr(&fillchars, 'fold:\zs.')
  let foldtextstart = strpart('+' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
  let foldtextend = lines_count_text . repeat(foldchar, 8)
  let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
  return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction
set foldtext=NeatFoldText()

"}}}2
"-------------------------------------------------------------------------------
" Diff mode:{{{2
"set diffopt+=iwhite "ignore white spaces
set diffopt+=vertical "force diff vertical split

"}}}2
"-------------------------------------------------------------------------------
" Mapping:{{{2
"set timeout         " do timeout on mappings
"set timeoutlen=500  " key map timeout after 100msec
"set ttimeout        " do timeout on terminal key codes
"set ttimeoutlen=50  " key code timeout after 0 sec

"}}}2
"-------------------------------------------------------------------------------
" Reading and writing files:{{{2
set fileformat=unix " Unix file format
set backup
set backupdir=~/.nvim-tmp/backup,~/.tmp,~/tmp,/var/tmp,/tmp
set noautowrite     " don't automatically write on :next, etc

"}}}2
"-------------------------------------------------------------------------------
" Swap file:{{{2
set directory=~/.nvim-tmp/swap,~/.tmp,~/tmp,/var/tmp,/tmp
set noswapfile
set updatecount=50 " write swap file to disk after each 20 characters
set updatetime=9000 " write swap file to disk after 9 inactive seconds

"}}}2
"-------------------------------------------------------------------------------
" Command line editing:{{{2
set history=1000     " size in line of history
set wildcharm=<C-z>  " see its use on mapping
set wildignore+=*.o,*.obj,*.a,*.so,*.exe,*.pyc,*.pyo,*.bak,*~,*.jpg,*.png,*.gif,*.class,*.swp " ignore this extensions
set wildignore+=*//.git/**/*,*/.hg/**/*,*/.svn/**/*
if exists("&wildignorecase")
    set wildignorecase
endif
set wildmenu
set wildoptions=fuzzy,pum
if exists('+undofile') | set undofile | endif
if exists('+undodir') | set undodir=~/.nvim-tmp/undo,~/.tmp,~/tmp,/var/tmp,/tmp | endif

"}}}2
"-------------------------------------------------------------------------------
" Running make and jumping to errors:{{{2
set grepprg=rg\ --vimgrep\ $*
set grepformat=%f:%l:%c:%m

"}}}2
"-------------------------------------------------------------------------------
" Various:{{{2
set virtualedit+=block
set secure
set sessionoptions+=unix,slash
set viminfo+='10,:20
"set debug=msg       " Setting this makes it show that error messages don't disappear after one second on startup.

"}}}2
"-------------------------------------------------------------------------------
" General:{{{2
"[NEOVIM] "set autochdir
"if has("unix")
"    behave xterm
"elseif has("win32")
"    behave mswin
"endif

set encoding=utf-8
"let &termencoding = &encoding
let &fileencoding = &encoding
let &fileencodings = &encoding

" Prevent Vim from clobbering the scrollback buffer. See
" http://www.shallowsky.com/linux/noaltscreen.html
"set t_ti= t_te=

" netrw lists file and folders in tree-like structure
let g:netrw_liststyle = 3
"}}}2
"-------------------------------------------------------------------------------
" Color:{{{2

"[NEOVIM] set term=$TERM

if $TERM =~ '^xterm'
    set t_Co=256
elseif $TERM =~ '^screen'
    set t_Co=256            " just guessing
elseif $TERM =~ '^tmux'
    set t_Co=256            " just guessing
elseif $TERM =~ '^rxvt'
    "set t_Co=88
    set t_Co=256
elseif $TERM =~ '^linux-16color'
    set t_Co=16
elseif $TERM =~ '^linux'
    set t_Co=8
else
    set t_Co=16
endif

if $TERM =~ '256color'
    " Disable Background Color Erase (BCE) so that color schemes
    " work properly when Vim is used inside tmux and GNU screen.
    " See also http://snk.tuxfamily.org/log/vim-256color-bce.html
    set t_ut=
endif

if &t_Co > 16
    "colorscheme gyrcolor
    "set term=xterm-256color
    "set term=screen-256color
    if has('termguicolors')
        set termguicolors
    endif
    "colorscheme 256_noir
    colorscheme ashen
endif

"}}}2
"-------------------------------------------------------------------------------
" Plugin:{{{2
" Disable Motorola Settings
let g:MotorolaLoadSettings = 1
" Disable IBM Settings
let g:IBMLoadSettings = 1

" clibs:{{{3
" clibs.vim : Syntax highlighting for C library functions and constants
let c_hi_identifiers = 'all'
let c_hi_libs = ['*']

" Vimwiki: {{{3
if isdirectory($HOME."/.config/nvim/pack/vendor/start/vimwiki")
    let gyr_wiki = {}
    let gyr_wiki.path = '~/.gyr.d/vimwiki/'
    let gyr_wiki.path_html = '~/.gyr.d/public_html/'
    let gyr_wiki.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'sh': 'sh', 'perl': 'perl', 'conf': 'conf', 'fstab': 'fstab', 'deb': 'debsources', 'resolv': 'resolv', 'xml': 'xml'}
    let g:vimwiki_list = [gyr_wiki]
    let g:vimwiki_hl_headers = 1
    let g:vimwiki_hl_cb_checked = 1
    "let g:vimwiki_folding = 1
    let g:vimwiki_fold_lists = 1
    let g:vimwiki_html_header_numbering = 1
endif

" vim-lsp: {{{3
let g:lsp_diagnostics_enabled = 0         " disable diagnostics support
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    "setlocal signcolumn=yes
    "if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    "nmap <buffer> gs <plug>(lsp-document-symbol-search)
    "nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    "nmap <buffer> gi <plug>(lsp-implementation)
    "nmap <buffer> gt <plug>(lsp-type-definition)
    "nmap <buffer> <leader>rn <plug>(lsp-rename)
    "nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    "nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    "nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    "nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

    "let g:lsp_format_sync_timeout = 1000
    "autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" ALE: {{{3
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
"[flake8] E032: expected 2 blank lines, found 1 [E]
let g:ale_use_neovim_diagnostics_api = 1

" FZF: {{{3
if isdirectory($HOME."/.config/nvim/pack/vendor/start/fzf.vim")
    " The mappings for scrolling the preview is done with FZF_DEFAULT_OPTS.
    " You can set this as an environment variable to have it work everywhere,
    " or put it in your vimrc like this.
    let $FZF_DEFAULT_OPTS="--bind \"ctrl-n:preview-down,ctrl-p:preview-up\""
    " For opening the selection in a new tab, ctrl-t already does this.
    " But you can change the mapping with:
    " let g:fzf_action = {'ctrl-o': 'tab split'}
endif
"}}}2
"-------------------------------------------------------------------------------

"}}}1
"===============================================================================
" Autocmd:{{{1
"""""""""""""""""""""""""""""""""""""""""""""""""
"               A U T O C M D                   "
"""""""""""""""""""""""""""""""""""""""""""""""""

augroup Gyr
    autocmd!

    " Insert mode
    autocmd InsertEnter * setlocal list nolinebreak
    autocmd InsertLeave * setlocal nopaste nolist linebreak

    autocmd InsertEnter *
                \ if &number == 1 |
                \   setlocal norelativenumber |
                \ endif
    autocmd InsertLeave *
                \ if &number == 1 |
                \   setlocal relativenumber |
                \ endif

    " Cursorline
    autocmd WinLeave * setlocal nocursorline nocursorcolumn
    autocmd WinEnter * setlocal cursorline

    "Return to last edit position
    autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   execute 'normal! g`"zvzz' |
        \ endif
augroup END

" Leave insert mode after 15 seconds of no input
"augroup CursorTimer
"    autocmd!
"    autocmd CursorHoldI * stopinsert
"    autocmd InsertEnter * let updaterestore=&updatetime | set updatetime=15000
"    autocmd InsertLeave * let &updatetime=updaterestore
"augroup END

augroup File_Type
    autocmd!
    " Prevent accidental editing .orig files
    autocmd BufRead *.orig set readonly

    autocmd BufEnter bash-fc-* setlocal filetype=sh

    autocmd FileType cpp,cc,h,hh,pl setlocal matchpairs+==:;

    autocmd FileType lua call gyrlib#ProgTextMode()

    autocmd Filetype php noremap <buffer><Leader>cs :php5 -l %<CR>
augroup END

" Endereço do arquivo de syntax
" http://aurelio.net/doc/vim/txt.vim    coloque em ~/.vim/syntax
"autocmd BufNewFile,BufRead *.txt source ~/.vim/after/syntax/txt.vim
"augroup Spell_Checker
"    "autocmd!
"    autocmd BufEnter,BufNew *.txt setlocal spell
"    " Git commits.
"    autocmd FileType gitcommit setlocal spell
"    " Subversion commits.
"    autocmd FileType svn       setlocal spell
"    " Mercurial commits.
"    autocmd FileType asciidoc  setlocal spell
"augroup END

if has("autocmd") && exists("+omnifunc")
    autocmd Filetype *
                \   if &omnifunc == "" |
                \       setlocal omnifunc=syntaxcomplete#Complete |
                \   endif
    " close preview window automatically without exiting insert mode for
    " omnicompletion (see completeopt)
    " http://vim.wikia.com/wiki/Omnicomplete_-_Remove_Python_Pydoc_Preview_Window
    autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
    autocmd InsertLeave * if pumvisible() == 0|pclose|endif
endif

" Secure GPG key handling
augroup Gpg
    autocmd!
    " Disable stuff and switch to binary mode to read the encrypted file.
    autocmd BufNewFile,BufReadPre,FileReadPre *.gpg set secure viminfo= noswapfile nobackup nowritebackup history=0 binary
    autocmd BufReadPost,FileReadPost *.gpg :%!gpg -d 2>/dev/null
    " Switch to normal mode for editing
    autocmd BufReadPost,FileReadPost *.gpg set nobinary
    " Convert all text to encrypted text before writing
    autocmd BufWritePre,FileWritePre *.gpg set binary
    autocmd BufWritePre,FileWritePre *.gpg :%!gpg -e -r 'Gustavo Yokoyama Ribeiro <gyr AT protonmail DOT ch>' 2>/dev/null
    " Undo all steath stuffs, back to normal text
    autocmd BufWritePost,FileWritePost *.gpg undo
augroup END

" Enc
augroup Enc
    autocmd!
    " Disable stuff and switch to binary mode to read the encrypted file.
    autocmd BufNewFile,BufReadPre,FileReadPre *.enc set secure viminfo= noswapfile nobackup nowritebackup history=0 binary
    autocmd BufReadPost,FileReadPost *.enc :%!openssl aes-256-cbc -d -a -salt 2>/dev/null
    " Switch to normal mode for editing
    autocmd BufReadPost,FileReadPost *.enc set nobinary
    " Convert all text to encrypted text before writing
    autocmd BufWritePre,FileWritePre *.enc set binary
    autocmd BufWritePre,FileWritePre *.enc :%!openssl aes-256-cbc -e -a -salt 2>/dev/null
    " Undo all steath stuffs, back to normal text
    autocmd BufWritePost,FileWritePost *.enc undo
augroup END

"}}}1
"===============================================================================
" Mapping:{{{1
"""""""""""""""""""""""""""""""""""""""""""""""""
"                 M A P P I N G                 "
"""""""""""""""""""""""""""""""""""""""""""""""""
" To insert a special character before it type (CTRL-v)
" In command mode <C-R> + register will return the register content in commnand line
" Do NOT user <F11> and <F12>, they have already been used by screen
" <Leader> = \ filename full path: expand("%:p") filename @%

"-------------------------------------------------------------------------------
" Miscelaneous:{{{2
nnoremap <silent><unique><leader>v :e ~/.config/nvim/vimrc.vim<CR>

" nnoremap <silent><unique><Leader><Insert> :setlocal paste!<Bar>echo 'Paste mode changed'<CR>

" Toggle show special chars
"nnoremap <silent><unique><Leader>li :set list! list?<CR>

" change directory to that of current file
"nnoremap <Leader>cd :cd%:p:h<cr>
" change local directory to that of current file
"nnoremap <Leader>lcd :lcd%:p:h<cr>

" 5*3=15, put the cursor in the first position and press <Leader>=
"map <unique><Leader>= <Esc>"myEEa=<C-R>=<C-R>m<CR><Esc>
" 5*3=15, when finish the expression press SHIFT+F1
"imap <unique><S-F1> <Space><Esc>"myBEa=<C-R>=<C-R>m<CR><Del>

"vnoremap <buffer> <silent> ;s <Esc>`>aSUFFIX<Esc>`<iPREFIX<Esc>
" vnoremap        Visual-mode keymap; no further expansion of the right-hand side
" <buffer>        Buffer-local. Won't apply in other buffers.
" <silent>        Mapping won't be echoed on the Vim command line
" ;s              Mapping is bound to sequence ;s
" <Esc>           Cancels selection
" `>              Go to end of former visual selection
" aSUFFIX<Esc>    Append SUFFIX
" `<              Go to beginning of former visual selection
" iPREFIX<Esc>    Insert PREFIX

"nnoremap <silent><unique><Leader>c :set cursorcolumn! cursorline!<CR>

nnoremap <unique><Leader>? ggVGg?

" The following beast is something i didn't write... it will return the
" syntax highlighting group that the current "thing" under the cursor
" belongs to -- very useful for figuring out what to change as far as
" syntax highlighting goes.
"nnoremap <silent><unique><Leader>cc :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" set text wrapping toggles
"nnoremap <silent><unique><Leader>w :set wrap!<CR>:set wrap?<CR>
"nnoremap <silent><unique><Leader><Bar> :set wrap linebreak nolist formatoptions-=t nonumber<CR>
"nnoremap <silent><unique><Leader><Bslash> :set nowrap nolinebreak list formatoptions+=t number<CR>

" set line number mode
"nnoremap <silent><unique><Leader>n :call gyrlib#ToggleNumberMode()<CR>

" highlight any text after virtual column 80
"nnoremap <silent><unique><Leader>h :match ErrorMsg '\%>80v.\+'<CR>
" disable highlight any text after virtual column 80
"nnoremap <silent><unique><Leader>h :match ErrorMsg '\%>80v.\-'<CR>

" Underline a line
nnoremap <unique><Leader>= yyp^v$r=
nnoremap <unique><Leader>- yyp^v$r-
vnoremap <unique><Leader>" o<ESC>i"<ESC>gvol<ESC>a"<ESC>l
vnoremap <unique><Leader>[ o<ESC>i[<ESC>gvol<ESC>a]<ESC>l
vnoremap <unique><Leader>{ o<ESC>i{<ESC>gvol<ESC>a}<ESC>l
vnoremap <unique><Leader>( o<ESC>i(<ESC>gvol<ESC>a)<ESC>l
vnoremap <unique><Leader>< o<ESC>i<<ESC>gvol<ESC>a><ESC>l
vnoremap <unique><Leader>' o<ESC>i'<ESC>gvol<ESC>a'<ESC>l
vnoremap <unique><Leader>` o<ESC>i`<ESC>gvol<ESC>a`<ESC>l

" very magic avoid the need to escape parenthesis, curly braces, pluses, etc
"nnoremap / /\v
"nnoremap ? ?\v
"
" Hide/Show Comments:
"nnoremap <unique><Leader>sc :hi! link Comment Ignore<CR>
"nnoremap <unique><Leader>hc :hi! link Comment Comment<CR>

" Better spell menu
"nnoremap <unique><Leader>s ea<C-X><C-S>

"nnoremap <unique><CR> o<ESC>
"nnoremap <unique><S-CR> O<ESC>
"
" https://github.com/paradigm/dotfiles/blob/master/.vimrc
" Create new text objects for pairs of identical characters
for char in ['$',',','.','/','-','=',':','_','*','+','%',';']
    exec 'xnoremap i' . char . ' :<C-U>silent!normal!T' . char . 'vt' . char . '<CR>'
    exec 'onoremap i' . char . ' :normal vi' . char . '<CR>'
    exec 'xnoremap a' . char . ' :<C-U>silent!normal!F' . char . 'vf' . char . '<CR>'
    exec 'onoremap a' . char . ' :normal va' . char . '<CR>'
endfor
" Create a text object for folding regions
"xnoremap if :<C-U>silent!normal![zjV]zk<CR>
"onoremap if :normal Vif<CR>
"xnoremap af :<C-U>silent!normal![zV]z<CR>
"onoremap af :normal Vaf<CR>

noremap <unique><Leader>sl :source $HOME/.nvim-tmp/sessions/*.vim<C-z>

" insert shebang
inoremap <expr> #! "#!" . substitute(system("which env"), "\n", "", "") . " " . &filetype

" format line
"noremap <unique><Leader>f gqip

" Show changes made to current buffer since the last save
noremap <unique><Leader>diff :w !delta -s % -<CR>

" if we have 3 * in a row make them into **/*
" this only applied on the nedn of a line
cnoremap <expr> * getcmdline() =~ '.*\*\*$' ? '/*' : '*'
"}}}2
"------------------------------------------------------------------------
" Insert Mode:{{{2
" paste previous insert text
"inoremap <unique><C-Y> <C-A>
" paste text above
"inoremap <unique><C-K> <C-Y>
" paste text below
"inoremap <unique><C-J> <C-E>


"}}}2
"-------------------------------------------------------------------------------
" Copy/Paste:{{{2
noremap Y y$
noremap <Leader>y "+y
noremap <Leader>d "+d
noremap <Leader>px :set paste<CR>:put  *<CR>:set nopaste<CR>
noremap <Leader>p :set paste<CR>:put  +<CR>:set nopaste<CR>
noremap <Leader>Px :set paste<CR>:put! *<CR>:set nopaste<CR>
noremap <Leader>P :set paste<CR>:put! +<CR>:set nopaste<CR>
" Paste and reformat/reindent
"nnoremap <unique><Leader>P P'[v']=
"nnoremap <unique><Leader>p p'[v']=
" Make shift-insert work like in Xterm
inoremap <S-Insert> <MiddleMouse>
"noremap! <S-Insert> <MiddleMouse>
" select last pasted text, via http://stackoverflow.com/a/4775281/955926
nnoremap <expr> gy "`[".getregtype(v:register)[0]."`]"

"}}}2
"-------------------------------------------------------------------------------
" Buffer:{{{2
" mapping mini-buffer
"nnoremap <silent><S-Tab> :bp<CR>:cd %:p:h<CR>
"nnoremap <silent><Tab> :bn<CR>:cd %:p:h<CR>
"nnoremap <Leader><Tab> <Leader>mbt
" Go to the alternate buffer
"nnoremap <silent><unique><Leader><Tab> :b#<CR>
"nnoremap <silent><unique><Tab> :bnext<CR>
"nnoremap <silent><unique><S-Tab> :bprevious<CR>
"nnoremap <silent><unique>[b :bprevious<CR>
"nnoremap <silent><unique>]b :bnext<CR>
"nnoremap <silent><unique>[B :bfirst<CR>
"nnoremap <silent><unique>]B :blast<CR>
nnoremap <silent><unique><Leader>b :ls<bar>let nr = input("Which one: ")<Bar>exec "b".nr<CR>
" OR see wildcharm on setting above
"nnoremap <unique><Leader>b :buffer <C-z>*
"nnoremap <silent><unique><Leader>c :clist<bar>let nr = input("Which one: ")<Bar>exec "cc".nr<CR>
"nnoremap <silent><unique><Leader>b :ls<CR>:sb<Space>
" Create a scratch buffer
nnoremap <silent><unique><Leader>zv :vnew<Bar>set buftype=nofile<Bar>echo "Scratch buffer"<CR>
nnoremap <silent><unique><Leader>zs :new<Bar>set buftype=nofile<Bar>echo "Scratch buffer"<CR>

"}}}2
"-------------------------------------------------------------------------------
"File:{{{2
nnoremap <unique><Leader>e :Lex<CR>
"nnoremap <unique><Leader>e. :edit %:p:h/**/*
"}}}2
"-------------------------------------------------------------------------------
" Tab:{{{2
"nnoremap <silent><unique>[t :tabprevious<CR>
"nnoremap <silent><unique>]t :tabnext<CR>
"nnoremap <silent><unique>[T :tabfirst<CR>
"nnoremap <silent><unique>]T :tablast<CR>

"}}}2
"-------------------------------------------------------------------------------
" Fixes:{{{2
" Disable enter 'Ex mode'
"noremap Q <Nop>
"noremap gQ <Nop>
" Don't use Ex mode, use Q for formatting
"noremap Q gq
"noremap q: <Nop>

noremap <F1> <Esc>
noremap! <F1> <Esc>

"}}}2
"-------------------------------------------------------------------------------
" Centralize Move And Search:{{{2
" make search results appear in the middle of the screen
nnoremap n nzvzz
nnoremap N Nzvzz
nnoremap * *zvzz
" Don't move on *
"nnoremap * *<C-O>
nnoremap # #zvzz<C-O>
nnoremap <C-]> <C-]>zvzz
nnoremap <C-T> <C-T>zvzz
noremap <silent><unique><Leader>zz  :let &scrolloff=999-&scrolloff<CR>

" next/previous word under cursor in same column
nnoremap g* yiw:let c=col('.')<CR>:let @/="^.*\\%".c.'c\zs'.@"<CR>n
nnoremap g# yiw:let c=col('.')<CR>:let @/="^.*\\%".c.'c\zs'.@"<CR>N

" move up/down between wrapped lines
" -- Changes up/down arrow keys to behave screen-wise, rather than file-wise.
"    Behaviour is unchanged in operator-pending mode.
"    Behaviour is unchanged for the j and k bindings.
nnoremap <expr>k v:count == 0 ? 'gk' : 'k'
nnoremap <expr>j v:count == 0 ? 'gj' : 'j'
"noremap 0 g0
"noremap $ g$
"noremap ^ g^

"noremap g0 0
"noremap g$ $
"noremap g^ ^

" Jumplist
" Older position in jumplist (<TAB> for newer position)
nnoremap <unique><S-Tab> <C-O>
"nnoremap <unique>[j <C-o>
"nnoremap <unique>]j <C-i>

nnoremap <unique><Leader>* [I:let nr = input("Which one: ")<Bar>exec "normal! ".nr."[\t"<CR>

" Search the selected text
vnoremap * y/<C-R>"<CR>
vnoremap # y?<C-R>"<CR>

if &diff
    nnoremap ]c ]czz
    nnoremap [c [czz
endif

"nnoremap <unique><S-Space> <C-U>

noremap <unique><Up> <C-Y>
noremap <unique><Down> <C-E>

" Small unimpaired map set
"noremap <unique>[a :previous<CR>
"noremap <unique>]a :next<CR>
"noremap <unique>[A :first<CR>
"noremap <unique>]A :last<CR>
"noremap <unique>[b :bprevious<CR>
"noremap <unique>]b :bnext<CR>
"noremap <unique>[B :bfirst<CR>
"noremap <unique>]B :blast<CR>
"noremap <unique>[l :lprevious<CR>
"noremap <unique>]l :lnext<CR>
"noremap <unique>[L :lfirst<CR>
"noremap <unique>]L :llast<CR>
"noremap <unique>[q :cprevious<CR>
"noremap <unique>]q :cnext<CR>
"noremap <unique>[Q :cfirst<CR>
"noremap <unique>]Q :clast<CR>

"}}}2
"-------------------------------------------------------------------------------
" Visual Mode:{{{2

if &diff
    " easily handle diffing
    vnoremap < :diffget<CR>
    vnoremap > :diffput<CR>
else
    " visual shifting (builtin-repeat)
    vnoremap < <gv
    vnoremap > >gv
endif
" allow the . to execute once for each line of a visual selection
vnoremap . :normal .<CR>

"}}}2
"-------------------------------------------------------------------------------
" Completion:{{{2
" bind Ctrl+Space for omnicompletion
inoremap <expr> <C-Space> pumvisible() \|\| &omnifunc == '' ?
            \ "<C-R>=gyrlib#SmartComplete()<CR>" :
            \ "<C-X><C-O>".
                \ "<C-R>=pumvisible() ?" .
                \ "\"\\<lt>C-P>\\<lt>C-N>\" :" .
                \ "\"\\<lt>C-X>\\<lt>C-N>\"<CR>"
" Completion popup selection like other IDEs
inoremap <expr> <Esc>      pumvisible() ? "\<C-E>" : "\<Esc>"
inoremap <expr> <CR>       pumvisible() ? "\<C-Y>" : "\<C-G>u\<CR>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-P>\<C-N>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-P>\<C-N>" : "\<PageUp>"
" move up/down between wrapped lines
" Stop remapping from interfering with Omni-complete popup
inoremap <expr><Up> pumvisible() ? "\<C-P>" : "\<C-O>gk"
inoremap <expr><Down> pumvisible() ? "\<C-N>" : "\<C-O>gj"

"}}}2
"-------------------------------------------------------------------------------
" Fold:{{{2
" n to use the <space> to represent characters without folding
" normal! za' toggles folds
" 'silent!' allows to avoid error message when current line doesn't delong to fold.
" (foldlevel('.')?'':'l') adds forward moving only if current line doesn't delong to fold.
"nnoremap <silent><unique><Space> :exe 'silent! normal! za'.(foldlevel('.')?'':'l').'zz'<CR>
nnoremap <silent><unique><expr> <Space> foldlevel('.') == 0 ? "\<C-D>" : ":exe 'silent! normal! za'.(foldlevel('.')?'':'l').'zz'\<CR>"
vnoremap <silent><unique><Space> :exe 'silent! normal! za'.(foldlevel('.')?'':'l').'zz'<CR>
"nnoremap <space> za

" Refocus folder
"nnoremap <unique><Leader>z zMzvzz

" <space> in visual mode creates a fold over the marked range
"vnoremap <unique><space> zf

" Make fold for {}
"nnoremap <Leader>f viBzf
"nnoremap <C-F> zfa{
" Make fold for all {}
"nnoremap <silent><unique><Leader>Fm :set foldmethod=marker foldmarker={,}<CR>
" Delete all folds
"noremap <silent><unique>zE :set foldmethod=manual<CR>zE
" Toggle fold recursively: zA
" Open all folds: zR
" Close all folds: zM

"}}}2
"-------------------------------------------------------------------------------
" Window:{{{2
" Resplit windows
nnoremap <C-W>y <C-W><C-W>:close<Bar>split #<CR>
nnoremap <C-W>Y <C-W><C-W>:close<Bar>vsplit #<CR>

"}}}2
"-------------------------------------------------------------------------------
" Plugins:{{{2
" FZF: {{{3
if isdirectory($HOME."/.config/nvim/pack/vendor/start/fzf.vim")
    nnoremap <leader>g :GitFiles<CR>
    nnoremap <leader><CR> :Files<CR>
    nnoremap <leader>b :Buffers<CR>
    nnoremap <leader>r :Rg! <C-R><C-W><CR>
    nnoremap <leader>l :Lines<CR>
    nnoremap <leader>h :History<CR>
endif

"}}}2
"-------------------------------------------------------------------------------

"}}}1
"===============================================================================
" Abbreviation:{{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""
"             A B B R E V I A T I O N S              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""
"-------------------------------------------------------------------------------
" Normal Mode:{{{2
" abbreviation for the current file name
" Equivalents to <C-R>%
"ab file,, <C-R>=expand("%:t")<CR><C-R>=gyrlib#EatChar('\s')<CR>
"ab file,, <C-R>=expand("%F")<CR><C-R>=gyrlib#EatChar('\s')<CR>
ab file,, <C-R>%<C-R>=gyrlib#EatChar('\s')<CR>
ab dirfile,, <C-R>=expand("%:p")<CR><C-R>=gyrlib#EatChar('\s')<CR>
ab dir,, <C-R>=expand("%:p:h")<CR><C-R>=gyrlib#EatChar('\s')<CR>
"}}}2
"-------------------------------------------------------------------------------
" Command Mode:{{{2
" Paste in commnad line the word under cursor
"cab p,, <C-R><C-W>
" If forgot to sudo vim a file, do that with :w!!
"cab w,, %!sudo tee > /dev/null %<CR>
"cab w,, %!sudo tee > /dev/null %<CR>
cab wsudo,, w !sudo tee % > /dev/null <CR>
" Copy the entire buffer to the system clipboard
cab y,, %y+<CR>

"}}}2
"-------------------------------------------------------------------------------
" Insert Mode: {{{2
iab gyr,, Gustavo Yokoyama Ribeiro<C-R>=gyrlib#EatChar('\s')<CR>
iab gyrmail,, Gustavo Yokoyama Ribeiro <gyr AT protonmail DOT ch><C-R>=gyrlib#EatChar('\s')<CR>
iab ts,, <C-R>=strftime("%Y%m%d %H:%M:%S")<cr><C-R>=gyrlib#EatChar('\s')<CR>
iab dt,, <C-R>=strftime("%Y%m%d")<cr><C-R>=gyrlib#EatChar('\s')<CR>
"}}}2
"-------------------------------------------------------------------------------
" Plugins: {{{2
" FZF: {{{3
if isdirectory($HOME."/.config/nvim/pack/vendor/start/fzf.vim")
    cab eg,, Files $HOME/.gyr.d/<CR>
    cab ev,, Files $HOME/.config/nvim/<CR>
    cab e.,, Files <C-R>=expand("%:p:h")<CR>/<CR>
else
    cab eg,, edit $HOME/.gyr.d/**/*<C-R>=gyrlib#EatChar('\s')<CR>
    cab ev,, edit $HOME/.config/nvim/**/*<C-R>=gyrlib#EatChar('\s')<CR>
    cab e.,, edit <C-R>=expand("%:p:h")<CR>/**/*<C-R>=gyrlib#EatChar('\s')<CR>
endif

"}}}2
"-------------------------------------------------------------------------------

"}}}1
"===============================================================================
" Command:{{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""
"               C O M M A N D S                      "
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
          \ | wincmd p | diffthis
endif

"}}}1
"===============================================================================
" GUI:{{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""
"               M I S C E L A N E O U S              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("gui_running")
    set guioptions+=c
    set guioptions-=r
    set guioptions-=L
    set guioptions-=T
    set mouse=

    "set guifont=ProggyCleanTTSZ\ 12
    "set guifont=Terminus\ 8
    "set guifont=Inconsolata\ for\ Powerline\ Medium\ 10
    "set guifont=Inconsolata\ 10
    set guifont=Hack\ 10
    "set guifont=Inconsolata-dz-Powerline \10
    "
    "colorscheme gyr_paleturquoise256
    "colorscheme gyrcolor
    colorscheme 256_noir
endif
if has("win32")
    set guifont=ProggyCleanSZ:h8:cDEFAULT
endif

"}}}1
"===============================================================================

"===============================================================================
" Tips & Tricks:{{{1

"-------------------------------------------------------------------------------
" Normal mode:{{{2
"
" cit   => change inside tag
" g;    => go to older changed position (backward)
" g,    => go to newer changed position (forward)
" '.    =>Location of last change
" CTRL-O => go to older jump list position
" CTRL-I => go to newer jump list position
" gi    => start inserting in the last insert position
" '^    => Location of last insertion
" gv    => repeat last visual selection
" ga    => code of character under cursor
" g?    => Rot13 encode (embaralha o texto)
" gn    => go to next match and select it
" g0    => begining of visual line
" g$    => end of visual line
" g_    => move to the last non-blank char of the line
" &     => Repeat last substitution on current line
" g&    => Repeat last substitution on all lines
" `[    =>Jump to beginning of last yanked text
" `]    =>Jump to end of last yanked text
" `<    =>Jump to beginning of last visual selection
" `>    =>Jump to end of last visual selection
" +     => Move to the first non-whitespace character of the next line
" S     => Delete current line and go into insert mode
" dat   => Delete around an HTML tag, including the tag
" dit   => Delete inside an HTML tag, excluding the tag
" m{letter}   => create a mark
" '{letter}   => use a mark
" [i    => show first occurence of pattern, for instance, show first variable attribution
" [I    => list of matching pattern
" ]]    => begin function
" ][    => end function
" !!<command> => replace the currnet line with the command output
" C-W C-] ==> Open the definition in a horizontal split
" gq}   => format sentence
" @<register> => execute the content of register, works with +, ., #, :, / like
"                C-R
" vi"p  => replace the text inside '"' with the content of default buffer
" q:    => show the command-line window :help cmdwin
" !<ESC>!<Motion> => you will get in command line if <Motion> = G:
" :.,$!
"
" }}}2
"-------------------------------------------------------------------------------
" Insertion mode:{{{2
"
" C-X s         => spell correction completion
" C-R "         => insert last delete/yank text
" C-R C-O "     => insert literal control characters last delete/yank text
" C-V 10<enter> => insert character code 10
" C-K NU        => insert character represented by the two letters
" C-R =         =>
" C-T           => add indent level
" C-D           => remove indent level
" C-y           => insert the character which is above the cursor.
" C-e           => insert the character which is below the cursor.
" C-O<cmd>      => execute one command, return to Insert mode
" C-\ C-O<cmd>  => like CTRL-O but don't move the cursor
" }}}2
"-------------------------------------------------------------------------------
" Visual mode:{{{2
"
" o     => switch cursor to the other corner, continue selection from there.
" }}}2
"-------------------------------------------------------------------------------
" Command mode:{{{2
"
" :digraphs => display table character codes
" :r!<command> => added command output on the next line
" :new +r!<command> => display commant output in a new window (remember to escape spaces "\ ")
" :<CTRL-D> => list command or files in directory
" :g/search_term/# => display each line containing 'search_term' with line numbers
" :vim /shoe/ **/*.java => vim `grep -Rl shoe | grep .java`
"         will find all java files under the current directory,
"         filter for ones containing the regex /shoe/, and queue them all up to be
"         edited. :cw will open the list, letting you jump between all those files.
" :h :w_c
" :bot term ++rows=5 => create a terminal with 5 rows at the botton

" No search o caractere & indica a string pela qual buscamos. Ex:
" teste
" :%s/teste/& concluído/
" teste concluído
"
" First line
" Second line.
" Thrid line.
" Forth line
" <char>\@<! exclude <char> from the search
" :%s/^.*\.@<!$/&./
" First line.
" Second line.
" Thrid line.
" Forth line.
"
" add a file or the output of a command in the file
" :read <filename>
" :read !<shell command>
"
" search echo in all files in arglist
" :vimgrep /echo/g ##
"
" select line \%l:
":1030,1040g/\%1034l\|\%1037l/p
" }}}2
"-------------------------------------------------------------------------------
" Explore mode:{{{2
"
" -  go back directory tree
" %  create a new file
" d  create a new directory
" R  rename the file/directory under the cursor
" D  Delete the file/directory under the cursor
" }}}2
"-------------------------------------------------------------------------------
" Terminal mode:{{{2
"
" on terminal buffer (:term)
" <C-w>N enter normal mode in terminal
" A exit normal mode
" <C-w>"" paste default register in terminal
" <C-w>: enter command mode in terminal
" }}}2
"-------------------------------------------------------------------------------

"<C-a> and <C-x> in normal mode to increment/decrement numbers.
"
"<C-v> to start visual-block mode.
"
"<C-w> in insert mode to delete the last typed word.
"
"<C-a> in insert mode to insert the last inserted text.
"
"<C-r>x and <C-r>= to insert the content of register x or the result of an expression. Useful in insert mode and on the command line. Also <C-r><C-w> to insert the current word in the command line.
"
"<C-o> and <C-i> to navigate the jumplist.
"
"<C-]> and <C-t> to go to definition and back.
"
"<C-f> and <C-b> to go page down and page up.

" Creating mappings that accept a count:
" http://vimcasts.org/episodes/creating-mappings-that-accept-a-count/
" Ex: nnoremap Q n.
" nnoremap Q @='n.'<CR>
" nnoremap Q :normal n.<CR>

" }}}1
"===============================================================================

" vim: set filetype=vim fileformat=unix foldmethod=marker:
