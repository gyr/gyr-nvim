-- Enable UI2
require("vim._core.ui2").enable({})
-- =============================================================================
-- 1. Security & Core Settings
-- =============================================================================
vim.opt.mouse = ""  -- disable mouse
vim.opt.cpoptions:append("$")
-- Paths & Searching
vim.opt.whichwrap:append("<,>,[,]")
--vim.opt.path:append("**")
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- Displaying Text
vim.opt.scrolloff = 5
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = "↪ "
vim.opt.fillchars = { diff = "↔", vert = "│" }
vim.opt.listchars = { tab = "▸▸", trail = "▪", eol = "¬", extends = "»", precedes = "«", nbsp = "ø", space = "·" }
vim.opt.sidescrolloff = 10
vim.opt.number = true
vim.opt.numberwidth = 1
-- Syntax & Highlight
vim.opt.background = "dark"
vim.opt.colorcolumn = "+1"
-- Split window
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.switchbuf = { "useopen", "usetab" }
-- Window Titles
vim.opt.title = true
vim.opt.titlestring = "%t%( [%R%M]%)"
-- Messages and Selection
vim.opt.report = 0
vim.opt.confirm = true
-- Editing Text
vim.opt.undolevels = 5000
vim.opt.formatoptions:append("t")
vim.opt.infercase = true
vim.opt.showmatch = true
vim.opt.matchtime = 2
vim.opt.matchpairs:append("<:>")

-- Optional: hide command bar until typing to use full screen height
vim.opt.cmdheight = 0

-- Enable rounded borders in floating windows
vim.opt.winborder = "rounded"

-- =============================================================================
-- 2. Formatting, Tabs & Indent
-- =============================================================================
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.shiftround = true
vim.opt.expandtab = true
--vim.opt.cindent = true
--vim.opt.cinoptions:append("l1,t0,i0,(0")

-- =============================================================================
-- 3. Wild Menu, Folds, Backup & Undofiles
-- =============================================================================
vim.opt.wildcharm = vim.api.nvim_replace_termcodes("<C-z>", true, true, true):byte()
vim.opt.wildignore:append({
    "*.o",
    "*.obj",
    "*.a",
    "*.so",
    "*.exe",
    "*.pyc",
    "*.pyo",
    "*.bak",
    "*~",
    "*.jpg",
    "*.png",
    "*.gif",
    "*.class",
    "*.swp",
    "*/.git/*", "*/.hg/*", "*/.svn/*",
})
vim.opt.wildignorecase = true
vim.opt.wildoptions:append("fuzzy")

-- Backup & Undos
-- (Neovim automatically saves undo files safely to ~/.local/state/nvim/undo/)
vim.opt.undofile = true
vim.opt.swapfile = false

-- Folds & Grep
vim.opt.foldopen:append({ "insert", "jump" })
if vim.fn.executable("rg") == 1 then
    vim.opt.grepprg = "rg --color=never --vimgrep "
end

-- Miscellaneous Options
vim.opt.virtualedit:append("block")
vim.opt.sessionoptions:append({ "unix", "slash" })

-- Diff Mode
vim.opt.diffopt:append({ "vertical", "algorithm:patience" })

-- =============================================================================
-- 4. Complex Blocks (Embedded in vim.cmd)
-- =============================================================================
vim.cmd([[
  " Folding text
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

  " Secure GPG and Openssl filters
  augroup Gpg
      autocmd!
      autocmd BufNewFile,BufReadPre,FileReadPre *.gpg set secure viminfo= noswapfile nobackup nowritebackup history=0 binary
      autocmd BufReadPost,FileReadPost *.gpg :%!gpg -d 2>/dev/null
      autocmd BufReadPost,FileReadPost *.gpg set nobinary
      autocmd BufWritePre,FileWritePre *.gpg set binary
      autocmd BufWritePre,FileWritePre *.gpg :%!gpg -e -r 'Gustavo Yokoyama Ribeiro <gyr AT protonmail DOT ch>' 2>/dev/null
      autocmd BufWritePost,FileWritePost *.gpg undo
  augroup END

  augroup Enc
      autocmd!
      autocmd BufNewFile,BufReadPre,FileReadPre *.enc set secure viminfo= noswapfile nobackup nowritebackup history=0 binary
      autocmd BufReadPost,FileReadPost *.enc :%!openssl aes-256-cbc -d -a -salt 2>/dev/null
      autocmd BufReadPost,FileReadPost *.enc set nobinary
      autocmd BufWritePre,FileWritePre *.enc set binary
      autocmd BufWritePre,FileWritePre *.enc :%!openssl aes-256-cbc -e -a -salt 2>/dev/null
      autocmd BufWritePost,FileWritePost *.enc undo
  augroup END
]])
