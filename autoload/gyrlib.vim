"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Author: Gustavo Yokoyama Ribeiro <gyr AT protonmail DOT ch>
" File:   gyrlib.vim
" Update: 20100822 01:44:24
" (C) Copyright 2010 Gustavo Yokoyama Ribeiro
" Licensed under CreativeCommons Attribution-ShareAlike 3.0 Unsupported
" http://creativecommons.org/licenses/by-sa/3.0/ for more info.
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if exists('g:loaded_gyrlib') || v:version < 702
    finish
endif
let s:keep_cpo = &cpo
set cpo&vim

"================================================================================
" FUNCTIONS:{{{1

"-------------------------------------------------------------------------------
" GLOBAL:{{{2

" gyrlib#EatChar:{{{3
function! gyrlib#EatChar(pat)
    let l:c = nr2char(getchar(0))
    return (l:c =~ a:pat) ? '' : c
endfunction
" }}}3

" gyrlib#AddFh:{{{3
function! gyrlib#AddFh(comment_char, comment_type)
    let l:line = 0
    if getline(1) =~ "^#!" && getline(1) =~"/bin/"
        let l:line = 1
    endif
    call append(l:line, repeat(a:comment_char, 80))
    call append((l:line+1), a:comment_char)
    call append((l:line+2), a:comment_char.' Author: Gustavo Yokoyama Ribeiro <gyr AT protonmail DOT ch>')
    call append((l:line+3), a:comment_char.' File:  '.expand("%:t"))
    call append((l:line+4), a:comment_char.' Update: '.strftime("%Y%m%d"))
    call append((l:line+5), a:comment_char.' (C) Copyright '.strftime("%Y").' Gustavo Yokoyama Ribeiro')
    call append((l:line+6), a:comment_char.' Licensed under CreativeCommons Attribution-ShareAlike 3.0 Unsupported')
    call append((l:line+7), a:comment_char.' http://creativecommons.org/licenses/by-sa/3.0/ for more info.')
    if a:comment_type == 'short'
        call append((l:line+8), a:comment_char)
        call append((l:line+9), repeat(a:comment_char, 80))
    elseif a:comment_type == 'full'
        call append((l:line+8), a:comment_char.' Description: ')
        call append((l:line+9), a:comment_char.' Usage: ')
        call append((l:line+10), a:comment_char)
        call append((l:line+11), repeat(a:comment_char, 80))
    endif
    return ''
endfunction
" }}}3

" gyrlib#MakeExecutable:{{{3
function! gyrlib#MakeExecutable()
    if getline(1) =~ "^#!" && getline(1) =~"/bin/"
        "silent !chmod u+x <afile>
        exec ":!chmod u+x %"
    else
        echo "Unable to make file executable!"
    endif
endfunction
" }}}3

" gyrlib#CallbackItem:{{{3
function gyrlib#CallbackItem(prompt, listener, list)
    echo "\n"
    if !empty(a:list)
        let l:index = 0
        for item in a:list
            echo l:index." ".item
            let l:index += 1
        endfor
        echo "\n"
        let l:input = input(a:prompt . " (<enter>=nothing) ")

        if strlen(l:input) > 0
            let l:items = split(l:input, ' ', 1)
            for item in l:items
                if !strlen(substitute(l:item, "[0-9]", "", "g")) > 0
                    try
                        call a:listener.onComplete(a:list[item], '')
                    catch
                        echohl WarningMsg | echo "\nERROR: Out of range" | echohl None
                    endtry
                else
                    echohl WarningMsg | echo "\nERROR: Not a number" | echohl None
                endif
            endfor
        else
            call a:listener.onAbort()
        endif
    else
        echohl WarningMsg | echo "ERROR: Empty list" | echohl None
    endif
endfunction
" }}}3

" gyrlib#ListenerLoadDiffFile:{{{3
let gyrlib#ListenerLoadDiffFile = {}
function! gyrlib#ListenerLoadDiffFile.onComplete(item, method)
    try
        execute "vert diffsplit ".a:item
    catch
        echohl WarningMsg | echo "ERROR: Diff file not loaded!" | echohl None
    endtry
endfunction

function! gyrlib#ListenerLoadDiffFile.onAbort()
    echohl WarningMsg | echo "Load diff file aborted!" | echohl None
endfunction
" }}}3

" gyrlib#ListenerLoadSession:{{{3
let gyrlib#ListenerLoadSession = {}
function! gyrlib#ListenerLoadSession.onComplete(item, method)
    try
        execute "source ".a:item
    catch
        echohl WarningMsg | echo "ERROR: Session not loaded!" | echohl None
    endtry
endfunction

function! gyrlib#ListenerLoadSession.onAbort()
    echohl WarningMsg | echo "Load session aborted!" | echohl None
endfunction
" }}}3

" gyrlib#DelTrailingSpaces:{{{3
function! gyrlib#DelTrailingSpaces()
    silent %s/\s\+$//e
    nohls
    normal! ``
endfunction
"}}}3

" gyrlib#BufcloseCloseIt:{{{3
" Don't close window, when deleting a buffer
"command! Bclose call <SID>BufcloseCloseIt()

function! gyrlib#BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        exec "bdelete! ".l:currentBufNum
    endif
endfunction
" command! Kwbd let kwbd_bn= bufnr("%")|enew|exe "bdel ".kwbd_bn|unlet kwbd_bn
" :Kwbd
" }}}3

" gyrlib#CommentOnOff:{{{3
" by http://aurelio.net
function! gyrlib#CommentOnOff()
    if !exists('b:hiddecomment')
        let b:hiddecomment=1 | highlight Comment ctermfg=black
    else
        unlet b:hiddecomment | highlight Comment ctermfg=darkgray
    endif
endfunction
" }}}3

" gyrlib#SaveCurrentSession:{{{3
function! gyrlib#SaveCurrentSession()
    try
        let l:session_name = input("Enter session file name (empty cancels): ")
        let l:session_dir = $HOME . "/.nvim-tmp/sessions"
        let l:session_ext = ".vim"
        if l:session_name != ''
            try
                if ! isdirectory(l:session_dir)
                    call mkdir(l:session_dir, "p")
                endif
                execute "cd / | mksession!" l:session_dir."/".l:session_name.l:session_ext." | cd"
                echo "\nSession" l:session_name "saved!"
            catch
                echohl WarningMsg | echo "\nERROR: Session not saved!" | echohl None
            endtry
        else
            echohl WarningMsg | echo "\nNo session file name entered!" | echohl None
        endif
    endtry
endfunction
" }}}3

" gyrlib#FindMate:{{{3
function! gyrlib#FindMate()
    let l:_name = input("Enter file pattern for ".getcwd()." (empty cancels): ")
    if l:_name != ""
        let l:_name = substitute(l:_name, "\\s", "*", "g")
        let l:items = system("find . -iname '*".l:_name."*' -not -name \"*.class\" -and -not -name \"*.swp\" -and -not -name \".*\"")
        let l:list = split(l:items, "\n")

        "call fuf#callbackitem#launch('', 0, ">File>", s:listenerFindMate, list, 0)
        call gyrlib#CallbackItem("Select file number", s:listenerFindMate, list)
    else
        echohl WarningMsg | echo "\nNo file pattern entered!" | echohl None
    endif
endfunction
" }}}3

" gyrlib#ToggleShowEvilspace:{{{3
function! gyrlib#ToggleShowEvilspace()
    if !exists('b:ws_show')
        let b:ws_show = 0
    endif
    if !exists('b:ws_flags')
        let b:ws_flags = 'est'  " default (which whitespace to show)
    endif
    if b:ws_show
        call <SID>ShowEvilspace(b:ws_flags)
        echo "Enable EvilSpace"
    else
        call <SID>ShowEvilspace('')
        echo "Disable EvilSpace"
    endif
    let b:ws_show = !b:ws_show
endfunction
" }}}3

" gyrlib#SmartComplete:{{{3
" Implement smart completion magic...
function! gyrlib#SmartComplete ()
    " Remember where we parked...
    let l:cursorpos = getpos('.')
    let l:cursorcol = l:cursorpos[2]
    let l:curr_line = getline('.')

    " Special subpattern to match only at cursor position...
    let l:curr_pos_pat = '\%' . l:cursorcol . 'c'

    " Tab as usual at the left margin...
    if l:curr_line =~ '^\s*' . l:curr_pos_pat
        return "\<TAB>"
    endif

    " How to restore the cursor position...
    let l:cursor_back = "\<C-O>:call setpos('.'," . string(l:cursorpos) . ")\<CR>"

    " If a matching smart completion has been specified, use that...
    for [left, right, completion, restore] in s:completions
        let l:pattern = left . l:curr_pos_pat . right
        if l:curr_line =~ l:pattern
            " Code around bug in setpos() when used at EOL...
            if l:cursorcol == strlen(l:curr_line)+1 && strlen(completion)==1
                let l:cursor_back = "\<LEFT>"
            endif

            " Return the completion...
            return completion . (restore ? l:cursor_back : "")
        endif
    endfor

    " If no contextual match and after an identifier, do keyword completion...
    if l:curr_line =~ '\k' . l:curr_pos_pat
        return "\<C-N>"

        " Otherwise, just be a <TAB>...
    else
        return "\<TAB>"
    endif
endfunction
" }}}3

" gyrlib#AddCompletion:{{{3
" Function to add user-defined completions...
function! gyrlib#AddCompletion (left, right, completion, restore)
    call insert(s:completions, [a:left, a:right, a:completion, a:restore])
endfunction
" }}}3

" gyrlib#EnsureDirExists:{{{3
function! gyrlib#EnsureDirExists (required_dir)
    if !isdirectory(a:required_dir)
        call <SID>AskQuit("Directory '" . a:required_dir . "' doesn't exist.", "&Create it?")

        try
            call mkdir( a:required_dir, 'p' )
        catch
            call <SID>AskQuit("Can't create '" . a:required_dir . "'", "&Continue anyway?")
        endtry
    endif
endfunction
" }}}3

" gyrlib#RunShellCommand:{{{3
function! gyrlib#RunShellCommand()
    let l:cmdline = input("Enter shell command: ")
    echo l:cmdline
    let expanded_cmdline = l:cmdline
    for part in split(l:cmdline, ' ')
        if part[0] =~ '\v[%#<]'
            let expanded_part = fnameescape(expand(part))
            let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
        endif
    endfor
    execute 'botright new'
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
    call setline(1, 'You entered:    ' . l:cmdline)
    call setline(2, 'Expanded Form:  ' .expanded_cmdline)
    call append(line('$'),substitute(getline(2),'.','=','g'))
    silent execute '$read!' . expanded_cmdline
    setlocal nomodifiable
    1
endfunction
"command! -complete=shellcmd -nargs=+ VShell call RunShellCommand('vnew', <q-args>)
" }}}3

" gyrlib#UpdateDate:{{{3
function! gyrlib#UpdateDate()
    if &ft == 'vim'
        if getline(5) =~ "\" Update: "
            silent exec "5s/\" Update: .*/\" Update: " . strftime("%Y%m%d %H:%M:%S") . "/"
            normal! ``
        endif
    elseif &ft == 'sh'
        if getline(6) =~ "# Update: "
            silent exec "6s/# Update: .*/# Update: " . strftime("%Y%m%d %H:%M:%S") . "/"
            normal! ``
        endif
    endif
endfunction
" }}}3

" gyrlib#ProgTextMode:{{{3
function! gyrlib#ProgTextMode()
    setlocal nowrap
    setlocal nolinebreak
    setlocal showbreak=
    "setlocal list
    "setlocal formatoptions+=t
    setlocal relativenumber
    setlocal number
    " We want to keep comments within an 80 column limit, but not code.
    " These two options give us that
    setlocal formatoptions-=t
    setlocal textwidth=80
endfunction
" }}}3

" gyrlib#ToggleTextMode:{{{3
function! gyrlib#ToggleTextMode()
    setlocal nowrap!
    setlocal nolinebreak!
    "setlocal list!
    setlocal norelativenumber!
    setlocal nonumber!
    " We want to keep comments within an 80 column limit, but not code.
    " These two options give us that
    setlocal formatoptions-=t
    setlocal textwidth=80
    "setlocal formatoptions+=t
    "if &textwidth == 0
    "    setlocal textwidth=80
    "else
    "    setlocal textwidth=0
    "endif
endfunction
" }}}3

" gyrlib#ToggleNumberMode:{{{3
function! gyrlib#ToggleNumberMode()
    if &relativenumber == 1
        setlocal relativenumber
    endif
endfunction
" }}}3

" gyrlib#NextTextObject{{{3
" https://gist.github.com/1171642
" usage: Motion for "next object". For example, "din(" would go to the next
" "()" pair and delete its contents.
function! gyrlib#NextTextObject(motion, dir)
    let c = nr2char(getchar())
    exe "normal! ".a:dir.c."v".a:motion.c
endfunction
" }}}3

" gyrlib#QuickfixFilenames{{{3
" http://vimcasts.org/episodes/project-wide-find-and-replace/
"command! -nargs=0 -bar Qargs execute 'args' gyrlib#QuickfixFilenames()
function! gyrlib#QuickfixFilenames()
    " Building a hash ensures we get each buffer only once
    let buffer_numbers = {}
    for quickfix_item in getqflist()
        let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
    endfor
    return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction
" }}}3

" gyrlib#VSetSearch{{{3
" http://vimcasts.org/episodes/search-for-the-selected-text/
function! gyrlib#VSetSearch(cmdtype)
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
    let @s = temp
endfunction
" }}}3

" gyrlib#MRU{{{3
" https://github.com/romainl/dotvim/blob/master/autoload/functions.vim
function! gyrlib#ListRecentFiles(ArgLead, CmdLine, CursorPos)
    let the_oldfiles = deepcopy(v:oldfiles)
    let my_oldfiles = filter(the_oldfiles, 'v:val =~ a:ArgLead')
    if len(my_oldfiles) > 16
        call remove(my_oldfiles, 17, len(my_oldfiles) - 1)
    endif
    return my_oldfiles
endfunction

function! gyrlib#MRU(command, arg)
    execute "" . a:command . " " . a:arg
endfunction
"}}}3

" gyrlib#DosToUnix{{{3
" https://github.com/romainl/dotvim/blob/master/autoload/functions.vim
function! gyrlib#DosToUnix()
    silent update
    silent edit ++ff=dos
    silent setlocal ff=unix
    silent write
endfunction
"}}}3

" [DISABLE]: gyrlib#LinterStatus{{{3
"function! gyrlib#LinterStatus() abort
"    let l:counts = ale#statusline#Count(bufnr(''))
"
"    let l:all_errors = l:counts.error + l:counts.style_error
"    let l:all_non_errors = l:counts.total - l:all_errors
"
"    return l:counts.total == 0 ? 'OK' : printf(
"    \   '%dW %dE',
"    \   all_non_errors,
"    \   all_errors
"    \)
"endfunction
"}}}3

" }}}2
"-------------------------------------------------------------------------------
" LOCAL:{{{2

" listenerFindMate {{{3
let s:listenerFindMate = {}
function! s:listenerFindMate.onComplete(item, method)
    if filereadable(a:item)
        execute "edit ".a:item
    else
        call s:listenerFindMate.onError("File does NOT exist!")
    endif
endfunction

function! s:listenerFindMate.onAbort()
    echohl WarningMsg | echo "\nFind file aborted!" | echohl None
endfunction
" }}}3

" ShowEvilspace:{{{3
" Highlight whitespace problems.
" flags is '' to clear highlighting, or is a string to
" specify what to highlight (one or more characters):
"   e  whitespace at end of line
"   i  spaces used for indenting
"   s  spaces before a tab
"   t  tabs not at start of line
function! s:ShowEvilspace(flags)
    let l:bad = ''
    let l:pat = []
    for c in split(a:flags, '\zs')
        if c == 'e'
            call add(l:pat, '\s\+$')
        elseif c == 'i'
            call add(l:pat, '^\t*\zs \+')
        elseif c == 's'
            call add(l:pat, ' \+\ze\t')
        elseif c == 't'
            call add(l:pat, '[^\t]\zs\t\+')
        else
            let l:bad .= c
        endif
    endfor
    if len(l:pat) > 0
        let l:s = join(l:pat, '\|')
        syntax clear TrailingSpaces TabChar
        exec 'syntax match Evilspace "'.l:s.'" containedin=ALL'
    else
        syntax clear Evilspace
    endif
    if len(l:bad) > 0
        echo 'ShowEvilspace ignored: '.l:bad
    endif
endfunction
" }}}3

" Variables:{{{3
" Table of completion specifications (a list of lists)...
let s:completions = []
" }}}3

" AskQuit:{{{3
function! s:AskQuit (msg, proposed_action)
    if confirm(a:msg, "&Quit?\n" . a:proposed_action) == 1
        exit
    endif
endfunction
" }}}3

" }}}2
"-------------------------------------------------------------------------------
" }}}1
"================================================================================

let g:loaded_gyrlib = 1
let &cpo = s:keep_cpo
unlet s:keep_cpo

" vim: set ft=vim ff=unix fdm=marker :
