local vimrc = vim.fn.stdpath("config") .. "/vimrc.vim"
vim.cmd.source(vimrc)

-- disable mouse
vim.cmd("set mouse=")

-- vim.cmd("colorscheme ashen")
require("ashen").load()

-- Enable rounded borders in floating windows
vim.o.winborder = "rounded"

vim.keymap.set("n", "<leader>n", ":e ~/.config/nvim/init.lua<CR>", { desc = 'Open init.lua' })

-- =============================================================================
-- LSP: lspconfig
-- =============================================================================
-- This function defines actions/keymaps that run when *any* LSP client attaches.
local on_attach = function(client, bufnr)
    -- Disable features on specific servers to manage conflicts
    if client.name == 'pyright' then
        -- Pyright's formatting is disabled to defer to conform.nvim
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false

    elseif client.name == 'ruff' then
        -- Ruff's core purpose is linting/fixes, so disable things Pyright handles better
        -- like hover/completion if they cause conflicts or visual clutter.
        client.server_capabilities.hoverProvider = false
        -- Note: Ruff does not provide completion, so no need to disable that.
    end

    -- Buffer-local keymaps for LSP features
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'grd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'grk', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'grf', vim.lsp.buf.format, { desc = 'Format current buffer using lsp' })
    -- grn in Normal mode maps to vim.lsp.buf.rename()
    -- grr in Normal mode maps to vim.lsp.buf.references()
    -- gri in Normal mode maps to vim.lsp.buf.implementation()
    -- gO in Normal mode maps to vim.lsp.buf.document_symbol() (this is analogous to the gO mappings in help buffers and :Man page buffers to show a “table of contents”)
    -- gra in Normal and Visual mode maps to vim.lsp.buf.code_action(): Use Code Action to apply lint fixes/suggestions from Ruff/Pyright:
    -- CTRL-S in Insert and Select mode maps to vim.lsp.buf.signature_help()
    -- [d and ]d move between diagnostics in the current buffer ([D jumps to the first diagnostic, ]D jumps to the last)
end

-- Create an Autocommand to run the 'on_attach' logic on LspAttach event
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('LspConfigPython', { clear = true }),
    callback = function(args)
        on_attach(vim.lsp.get_client_by_id(args.data.client_id), args.buf)
    end,
})

-- A. Configure Pyright (Core LSP and Type Checking)
-- We override the default config provided by nvim-lspconfig
vim.lsp.config('pyright', {
    -- We attach the general on_attach function via the Autocommand above
    settings = {
        python = {
            analysis = {
                -- Crucial: Disable general linting in Pyright to use Ruff instead
                ignore = { '*' },
                typeCheckingMode = 'strict',
            },
        },
        pyright = {
            -- Disable Pyright's auto-organize to let Ruff handle it
            disableOrganizeImports = true,
        },
    }
})

-- B. Configure Ruff (Real-time Linting and Fixes)
-- We attach the general on_attach function via the Autocommand above
vim.lsp.config('ruff', {
    -- Ruff server is configured by nvim-lspconfig to run the 'ruff server' command
    init_options = {
        -- Ruff-specific settings can go here if needed
        logLevel = 'warning',
    },
})

vim.lsp.config("lua_ls", {
    -- Server-specific settings. See `:help lsp-quickstart`
    settings = {
        Lua = {
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            },
        },
    },
})

vim.lsp.config("gopls", {
    settings = {
        gopls = {
            analyses = {unusedparams = true},
            staticcheck = true,
        },
    },
})

vim.lsp.enable("pyright")
vim.lsp.enable("ruff")
vim.lsp.enable("lua_ls")
vim.lsp.enable("gopls")

-- =============================================================================
-- FORMATTING: conform
-- =============================================================================
local conform = require("conform")

conform.setup({
    -- Define Ruff Format as the dedicated formatter for Python
    formatters_by_ft = {
        python = { "ruff_format" },
    },
    -- Format on save logic
    -- Explicitly set format_on_save to false or nil
    -- This prevents the BufWritePre autocmd from being installed.
    format_on_save = nil,
    -- uncomment lines below to enable format on save
    -- format_on_save = {
    --     async = true,
    --     timeout_ms = 500,
    --     -- 'lsp_format = "never"' ensures we rely ONLY on ruff_format and not Pyright/Ruff LSPs for formatting
    --     lsp_format = "never",
    --     pattern = { "*.py" },
    --     callback = function(args)
    --         conform.format({
    --             bufnr = args.buf,
    --             async = true,
    --             timeout_ms = 500,
    --         })
    --     end,
    -- },
})

-- Keymap for manual formatting
vim.keymap.set({ "n", "v" }, "<leader>fmt", function()
    conform.format({
        --  ensures we rely ONLY on ruff_format and not Pyright/Ruff LSPs for formatting
        lsp_format = "never",
        -- Run synchronously: wait for format before returning control
        async = false,
        timeout_ms = 1000,
    })
end, { desc = "Format file or range using Ruff (no auto-save)" })

-- =============================================================================
-- AUTO-COMPLETIOTN: blink
-- =============================================================================
local blink = require("blink.cmp")
blink.setup({
    -- Display a preview of the selected item on the current line
    completion = {
        -- 'prefix' will fuzzy match on the text before the cursor
        -- 'full' will fuzzy match on the text before _and_ after the cursor
        -- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
        keyword = { range = "full" },
        -- Show documentation when selecting a completion item
        -- C-space: Open menu or open docs if already open
        --documentation = { auto_show = true, auto_show_delay_ms = 500 },
        menu = {
            draw = {
                treesitter = { "lsp" },
            },
        },
        list = {
            selection = {
                preselect = function(ctx)
                    return not require("blink.cmp").snippet_active({ direction = 1 })
                end,
            },
        },
        -- Display a preview of the selected item on the current line
        ghost_text = { enabled = true },
    },
    keymap = {
        preset = "enter",

        ["<Tab>"] = {
            function(cmp)
                if cmp.snippet_active() then
                    return cmp.accept()
                else
                    return cmp.select_next()
                end
            end,
            "snippet_forward",
            "fallback",
        },
        ["<S-Tab>"] = {
            function(cmp)
                if cmp.snippet_active() then
                    return cmp.accept()
                else
                    return cmp.select_prev()
                end
            end,
            "snippet_backward",
            "fallback",
        },
    },
    cmdline = {
        enabled = true,
        completion = {
            menu = { auto_show = true },
            list = {
                selection = { preselect = false },
            },
        },
    },
    sources = {
        default = { "lsp", "buffer", "snippets", "path", "omni" },
    },
    -- Experimental signature help support
    --signature = { enabled = true },
    -- Use a preset for snippets, check the snippets documentation for more information
    -- snippets = { preset = "default" | "luasnip" | "mini_snippets" },
    fuzzy = { implementation = "lua" },
})

-- =============================================================================
-- nvim-treesitter
-- =============================================================================
require("nvim-treesitter.configs").setup({
    -- A list of parser names, or "all" (the listed parsers MUST always be installed)
    ensure_installed = { "lua", "vim", "python", "xml", "yaml", "bash", "go" },

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
})

-- nvin-treesitter-context
require("treesitter-context").setup({
    enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
    multiwindow = false,      -- Enable multiwindow support.
    max_lines = 0,            -- How many lines the window should span. Values <= 0 mean no limit.
    min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
    line_numbers = true,
    multiline_threshold = 20, -- Maximum number of lines to show for a single context
    trim_scope = "outer",     -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    mode = "cursor",          -- Line used to calculate context. Choices: 'cursor', 'topline'
    -- Separator between context and content. Should be a single character string, like '-'.
    -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
    separator = nil,
    zindex = 20,     -- The Z-index of the context window
    on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
})

vim.cmd("hi TreesitterContextBottom gui=underline guisp=Grey")
vim.cmd("hi TreesitterContextLineNumberBottom gui=underline guisp=Grey")

-- nvim-treesitter-textobjects
require("nvim-treesitter.configs").setup({
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
                ["@parameter.outer"] = "v", -- charwise
                ["@function.outer"] = "V",  -- linewise
                ["@class.outer"] = "<c-v>", -- blockwise
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
            },
        },
        require("nvim-treesitter.configs").setup({
            textobjects = {
                lsp_interop = {
                    enable = true,
                    border = "rounded",
                    floating_preview_opts = {},
                    peek_definition_code = {
                        ["<leader>df"] = "@function.outer",
                        ["<leader>dF"] = "@class.outer",
                    },
                },
            },
        }),
    },
})

-- =============================================================================
-- indent-blankline
-- =============================================================================
require("ibl").setup()

-- =============================================================================
-- fzf-lua
-- =============================================================================
vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = 'FZF for files in current dir' })
vim.keymap.set("n", "<leader>ffh", "<cmd>FzfLua files cwd=~/<cr>", { desc = 'FZF for files in home dir' })
vim.keymap.set("n", "<leader>ffg", "<cmd>FzfLua files cwd=~/.gyr.d/<cr>", { desc = 'FZF for files in gyr.d dir' })
vim.keymap.set("n", "<leader>ffs", "<cmd>FzfLua files cwd=~/.gyr.d/suse.d/<cr>", { desc = 'FZF for files in suse dir' })
vim.keymap.set("n", "<leader>ffv", "<cmd>FzfLua files cwd=~/.config/nvim/<cr>", { desc = 'FZF for files in nvim dir' })
vim.keymap.set("n", "<leader>fh", "<cmd>FzfLua oldfiles<cr>", { desc = 'FZF for files in history' })

vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<cr>", { desc = 'FZF for open buffers' })
vim.keymap.set("n", "<leader>fq", "<cmd>FzfLua quickfix<cr>", { desc = 'FZF for quickfix list' })
vim.keymap.set("n", "<leader>fl", "<cmd>FzfLua blines<cr>", { desc = 'FZF for current buffer line' })
vim.keymap.set("n", "<leader>ft", "<cmd>FzfLua treesitter<cr>", { desc = 'FZF for treesitter symbols' })

vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<cr>", { desc = 'FZF for file current project' })

vim.keymap.set("n", "<leader>flr", "<cmd>FzfLua lsp_references<cr>", { desc = 'FZF for references' })
vim.keymap.set("n", "<leader>fli", "<cmd>FzfLua lsp_implementations<cr>", { desc = 'FZF for implementations' })

vim.keymap.set("n", "<leader>fr", "<cmd>FzfLua registers<cr>", { desc = 'FZF for registers' })
vim.keymap.set("n", "<leader>fk", "<cmd>FzfLua keymaps<cr>", { desc = 'FZF for keymaps' })
vim.keymap.set("n", "<leader>fm", "<cmd>FzfLua marks<cr>", { desc = 'FZF for marks' })
vim.keymap.set("n", "<leader>fj", "<cmd>FzfLua jumps<cr>", { desc = 'FZF for jumps' })

-- =============================================================================
-- terminal
-- =============================================================================
local function open_bottom_terminal(height)
    vim.cmd("botright split term://bash")
    local terminal_win = vim.api.nvim_get_current_win() -- Get the terminal window
    vim.api.nvim_win_set_height(terminal_win, height)
    vim.cmd("wincmd j")                                 -- Move focus back to the original window
end

vim.api.nvim_create_user_command("BottomTerm", function(args)
    local height = tonumber(args.args) or 10
    open_bottom_terminal(height)
end, { nargs = "?" })

vim.keymap.set("n", "<leader>t", ":BottomTerm<CR>", { desc = 'Open terminal at the botton' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- =============================================================================
-- DIAGNOSTICS
-- =============================================================================

-- nvim 0.11: https://gpanders.com/blog/whats-new-in-neovim-0-11
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

-- diagnostic-toggle-virtual-lines-example
-- https://neovim.io/doc/user/diagnostic.html#diagnostic-toggle-virtual-lines-example
vim.keymap.set("n", "gK", function()
    local new_config = not vim.diagnostic.config().virtual_lines
    vim.diagnostic.config({ virtual_lines = new_config })
end, { desc = "Toggle diagnostic virtual_lines" })
vim.keymap.set('n', '<leader>Q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- =============================================================================
-- Highlight when yanking (copying) text
-- =============================================================================
-- https://github.com/adibhanna/minimal-vim/blob/main/lua/config/autocmds.lua
--vim.api.nvim_create_autocmd('TextYankPost', {
--    desc = 'Highlight when yanking (copying) text',
--    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
--    callback = function()
--        vim.highlight.on_yank()
--    end,
--})

-- =============================================================================
-- Highlight the element under cursor
-- =============================================================================
vim.api.nvim_create_autocmd({'CursorHold'}, {
    buffer = bufnr, -- current buffer number
    callback = function()
        vim.lsp.buf.document_highlight()
    end,
})

vim.api.nvim_create_autocmd({'CursorMoved'}, {
    buffer = bufnr,
    callback = function()
        vim.lsp.buf.clear_references()
    end,
})

-- Set the color of highlighted element
vim.api.nvim_set_hl(0, "LspReferenceText", { bg = "#444444", fg = "#FFFFFF" })

-- Set update time to 500 milliseconds (0.5 seconds) to fix CursorHold trigger
-- time
vim.opt.updatetime = 500

-- =============================================================================
-- tiny-glimmer
-- =============================================================================
require("tiny-glimmer").setup({
    -- Enable/disable the plugin
    enabled = true,

    -- Disable warnings for debugging highlight issues
    disable_warnings = true,

    -- Animation refresh rate in milliseconds
    refresh_interval_ms = 8,

    -- Automatic keybinding overwrites
    overwrite = {
        -- Automatically map keys to overwrite operations
        -- Set to false if you have custom mappings or prefer manual API calls
        auto_map = true,

        -- Yank operation animation
        yank = {
            enabled = true,
            default_animation = "fade",
        },

        -- Search navigation animation
        search = {
            enabled = true,
            default_animation = "pulse",
            next_mapping = "n",      -- Key for next match
            prev_mapping = "N",      -- Key for previous match
        },

        -- Paste operation animation
        paste = {
            enabled = true,
            default_animation = "reverse_fade",
            paste_mapping = "p",     -- Paste after cursor
            Paste_mapping = "P",     -- Paste before cursor
        },

        -- Undo operation animation
        undo = {
            enabled = true,
            default_animation = {
                name = "fade",
                settings = {
                    from_color = "DiffDelete",
                    max_duration = 500,
                    min_duration = 500,
                },
            },
            undo_mapping = "u",
        },

        -- Redo operation animation
        redo = {
            enabled = true,
            default_animation = {
                name = "fade",
                settings = {
                    from_color = "DiffAdd",
                    max_duration = 500,
                    min_duration = 500,
                },
            },
            redo_mapping = "<c-r>",
        },
    },

    -- Third-party plugin integrations
    support = {
        -- Support for gbprod/substitute.nvim
        -- Usage: require("substitute").setup({
        --     on_substitute = require("tiny-glimmer.support.substitute").substitute_cb,
        --     highlight_substituted_text = { enabled = false },
        -- })
        substitute = {
            enabled = false,
            default_animation = "fade",
        },
    },

    -- Special animation presets
    presets = {
        -- Pulsar-style cursor highlighting on specific events
        pulsar = {
            enabled = true,
            on_events = { "CursorMoved", "CmdlineEnter", "WinEnter" },
            default_animation = {
                name = "fade",
                settings = {
                    max_duration = 1000,
                    min_duration = 1000,
                    from_color = "DiffDelete",
                    to_color = "Normal",
                },
            },
        },
    },

    -- Override background color for animations (for transparent backgrounds)
    transparency_color = nil,

    -- Animation configurations
    animations = {
        fade = {
            max_duration = 400,              -- Maximum animation duration in ms
            min_duration = 300,              -- Minimum animation duration in ms
            easing = "outQuad",              -- Easing function
            chars_for_max_duration = 10,    -- Character count for max duration
            from_color = "Visual",           -- Start color (highlight group or hex)
            to_color = "Normal",             -- End color (highlight group or hex)
        },
        reverse_fade = {
            max_duration = 380,
            min_duration = 300,
            easing = "outBack",
            chars_for_max_duration = 10,
            from_color = "Visual",
            to_color = "Normal",
        },
        bounce = {
            max_duration = 500,
            min_duration = 400,
            chars_for_max_duration = 20,
            oscillation_count = 1,          -- Number of bounces
            from_color = "Visual",
            to_color = "Normal",
        },
        left_to_right = {
            max_duration = 350,
            min_duration = 350,
            min_progress = 0.85,
            chars_for_max_duration = 25,
            lingering_time = 50,            -- Time to linger after completion
            from_color = "Visual",
            to_color = "Normal",
        },
        pulse = {
            max_duration = 600,
            min_duration = 400,
            chars_for_max_duration = 15,
            pulse_count = 2,                -- Number of pulses
            intensity = 1.2,                -- Pulse intensity
            from_color = "Visual",
            to_color = "Normal",
        },
        rainbow = {
            max_duration = 600,
            min_duration = 350,
            chars_for_max_duration = 20,
            -- Note: Rainbow animation does not use from_color/to_color
        },

        -- Custom animation example
        custom = {
            max_duration = 350,
            chars_for_max_duration = 40,
            color = "#ff0000",  -- Custom property

            -- Custom effect function
            -- @param self table - The effect object with settings
            -- @param progress number - Animation progress [0, 1]
            -- @return string color - Hex color or highlight group
            -- @return number progress - How much of the animation to draw
            effect = function(self, progress)
                return self.settings.color, progress
            end,
        },
    },

    -- Filetypes to disable hijacking/overwrites
    hijack_ft_disabled = {
        "alpha",
        "snacks_dashboard",
    },

    -- Virtual text display priority
    virt_text = {
        priority = 2048,  -- Higher values appear above other plugins
    },
})
