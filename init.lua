local vimrc = vim.fn.stdpath("config") .. "/vimrc.vim"
vim.cmd.source(vimrc)

-- disable mouse
vim.cmd("set mouse=")

-- vim.cmd("colorscheme ashen")
require("ashen").load()

-- Enable rounded borders in floating windows
vim.o.winborder = 'rounded'

-- cmp-nvim-lsp
-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspconfig = require('lspconfig')

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 'pyright', 'lua_ls' }
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        -- on_attach = my_custom_on_attach,
        capabilities = capabilities,
    }
end

-- nvim-cmp
local cmp = require 'cmp'
cmp.setup {
     window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
        ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
        -- C-b (back) C-f (forward) for snippet placeholder navigation.
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    sources = {
        { name = 'nvim_lsp' },
    },
}

-- cmp-cmdline
-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})

-- nvim-treesitter
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = { "lua", "vim", "python", "xml", "yaml", "bash" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,
    -- list of language that will be disabled
    -- disable = { "c", "rust" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

-- nvin-treesitter-context
require'treesitter-context'.setup{
  enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  multiwindow = false, -- Enable multiwindow support.
  max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
  min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  line_numbers = true,
  multiline_threshold = 20, -- Maximum number of lines to show for a single context
  trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
  -- Separator between context and content. Should be a single character string, like '-'.
  -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
  separator = nil,
  zindex = 20, -- The Z-index of the context window
  on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
}

vim.cmd("hi TreesitterContextBottom gui=underline guisp=Grey")
vim.cmd("hi TreesitterContextLineNumberBottom gui=underline guisp=Grey")

-- nvim-treesitter-textobjects
require'nvim-treesitter.configs'.setup {
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        -- You can optionally set descriptions to the mappings (used in the desc parameter of
        -- nvim_buf_set_keymap) which plugins like which-key display
        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
        -- You can also use captures from other query groups like `locals.scm`
        ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
      },
      -- You can choose the select mode (default is charwise 'v')
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * method: eg 'v' or 'o'
      -- and should return the mode ('v', 'V', or '<c-v>') or a table
      -- mapping query_strings to modes.
      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@function.outer'] = 'V', -- linewise
        ['@class.outer'] = '<c-v>', -- blockwise
      },
      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding or succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * selection_mode: eg 'v'
      -- and should return true or false
      include_surrounding_whitespace = true,
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = { query = "@class.outer", desc = "Next class start" },
        --
        -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
        -- ["]o"] = "@loop.*",
        -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
        --
        -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
        -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
        ["]s"] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
        ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
      -- Below will go to either the start or the end, whichever is closer.
      -- Use if you want more granular movements
      -- Make it even more gradual by adding multiple queries and regex.
      goto_next = {
        ["]o"] = "@loop.outer",
        ["]i"] = "@conditional.outer",
      },
      goto_previous = {
        ["[o"] = "@loop.outer",
        ["[i"] = "@conditional.outer",
      }
    },
    require'nvim-treesitter.configs'.setup {
        textobjects = {
            lsp_interop = {
                enable = true,
                border = 'rounded',
                floating_preview_opts = {},
                peek_definition_code = {
                    ["<leader>df"] = "@function.outer",
                    ["<leader>dF"] = "@class.outer",
                },
            },
        },
    },
  },
}

-- indent-blankline
require("ibl").setup()

-- fzf-lua
vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<cr>")
vim.keymap.set("n", "<leader>ffh", "<cmd>FzfLua files cwd=~/<cr>")
vim.keymap.set("n", "<leader>ffg", "<cmd>FzfLua files cwd=~/.gyr.d/<cr>")
vim.keymap.set("n", "<leader>ffs", "<cmd>FzfLua files cwd=~/.gyr.d/suse.d/<cr>")
vim.keymap.set("n", "<leader>ffv", "<cmd>FzfLua files cwd=~/.config/nvim/<cr>")
vim.keymap.set("n", "<leader>fh", "<cmd>FzfLua oldfiles<cr>")

vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<cr>")
vim.keymap.set("n", "<leader>fq", "<cmd>FzfLua quickfix<cr>")
vim.keymap.set("n", "<leader>fl", "<cmd>FzfLua blines<cr>")
vim.keymap.set("n", "<leader>ft", "<cmd>FzfLua treesitter<cr>")

vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<cr>")

vim.keymap.set("n", "<leader>flr", "<cmd>FzfLua lsp_references<cr>")
vim.keymap.set("n", "<leader>fli", "<cmd>FzfLua lsp_implementations<cr>")

vim.keymap.set("n", "<leader>fr", "<cmd>FzfLua registers<cr>")
vim.keymap.set("n", "<leader>fk", "<cmd>FzfLua keymaps<cr>")
vim.keymap.set("n", "<leader>fm", "<cmd>FzfLua marks<cr>")
vim.keymap.set("n", "<leader>fj", "<cmd>FzfLua jumps<cr>")

-- terminal
local function open_bottom_terminal(height)
  vim.cmd("botright split term://bash")
  local terminal_win = vim.api.nvim_get_current_win() -- Get the terminal window
  vim.api.nvim_win_set_height(terminal_win, height)
  vim.cmd("wincmd j") -- Move focus back to the original window
end

vim.api.nvim_create_user_command('BottomTerm', function(args)
  local height = tonumber(args.args) or 10
  open_bottom_terminal(height)
end, { nargs = '?' })

vim.keymap.set("n", "<leader>t", ":BottomTerm<CR>")

vim.keymap.set("n", "<leader>n", ":e ~/.config/nvim/init.lua<CR>")

-- nvim 0.11: https://gpanders.com/blog/whats-new-in-neovim-0-11
-- Diagnostics
-- Virtual text handler changed from opt-out to opt-in
vim.diagnostic.config({
  -- Use the default configuration
  -- virtual_lines = true
  -- virtual_text = true

  -- Alternatively, customize specific options
   virtual_lines = {
   -- Only show virtual line diagnostics for the current cursor line
   current_line = true,
  },
  -- virtual_text = {
  --     current_line = true,
  -- },
})

-- grn in Normal mode maps to vim.lsp.buf.rename()
-- grr in Normal mode maps to vim.lsp.buf.references()
-- gri in Normal mode maps to vim.lsp.buf.implementation()
-- gO in Normal mode maps to vim.lsp.buf.document_symbol() (this is analogous to the gO mappings in help buffers and :Man page buffers to show a “table of contents”)
-- gra in Normal and Visual mode maps to vim.lsp.buf.code_action()
-- CTRL-S in Insert and Select mode maps to vim.lsp.buf.signature_help()
-- [d and ]d move between diagnostics in the current buffer ([D jumps to the first diagnostic, ]D jumps to the last)

