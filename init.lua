-- =============================================================================
-- PLUGIN MANAGEMENT: vim.pack (Neovim 0.12)
-- =============================================================================
vim.pack.add({
    "https://github.com/ashen-org/ashen.nvim",
    "https://github.com/Saghen/blink.lib",  -- Required by blink.cmp v2
    "https://github.com/Saghen/blink.cmp",
    "https://github.com/stevearc/conform.nvim",
    "https://github.com/ibhagwan/fzf-lua",
    "https://github.com/lukas-reineke/indent-blankline.nvim",
    "https://github.com/brennovich/marques-de-itu",
    -- Supplies the lsp/*.lua definitions (cmd, filetypes, root_markers) that
    -- vim.lsp.config()/vim.lsp.enable() below extend. Without it no server starts.
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/nvim-treesitter/nvim-treesitter-context",
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
    "https://github.com/rachartier/tiny-glimmer.nvim",
    "https://github.com/andreasvc/vim-256noir",
    "https://github.com/tpope/vim-fugitive",
    "https://github.com/mhinz/vim-signify",
    "https://github.com/tpope/vim-unimpaired",
    "https://github.com/vimwiki/vimwiki",
    "https://github.com/carlos-algms/agentic.nvim",
})

-- =============================================================================
-- SOURCE VIMRC
-- =============================================================================
local vimrc = vim.fn.stdpath("config") .. "/vimrc.vim"
vim.cmd.source(vimrc)

-- disable mouse
vim.cmd("set mouse=")

--require("ashen").load()
vim.cmd("colorscheme marques-de-itu")

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
    local function map(lhs, rhs, desc)
        vim.keymap.set('n', lhs, rhs, { noremap = true, silent = true, buffer = bufnr, desc = desc })
    end
    map('grd', vim.lsp.buf.definition, 'Go to definition')
    map('grk', vim.lsp.buf.hover, 'Show hover documentation')
    map('grf', vim.lsp.buf.format, 'Format current buffer using lsp')
    -- grt in Normal mode maps to vim.lsp.buf.type_definition()
    -- grx in Normal mode maps to vim.lsp.codelens.run()
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
-- nvim-treesitter (main branch)
-- =============================================================================
-- The `main` rewrite removed the module system: setup() only reads `install_dir`,
-- so `ensure_installed`, `highlight`, `incremental_selection` and `textobjects`
-- are no longer honoured. Parsers are installed with install(); highlighting is
-- provided by Neovim core and must be started per buffer.
-- See :h treesitter-highlight and the plugin README.
local ts_parsers = {
    "bash", "go", "json", "lua", "markdown", "markdown_inline",
    "python", "vim", "xml", "yaml",
}

-- Asynchronous, and a no-op for parsers that are already present
require("nvim-treesitter").install(ts_parsers)

-- Skip treesitter highlighting on large files (replaces `highlight.disable`)
local ts_max_filesize = 100 * 1024 -- 100 KB

-- Incremental selection. Core provides an/in/]n/[n/]N/[N
-- (:h treesitter-incremental-selection), but an/in are shadowed by the
-- NextTextObject mappings in after/plugin/gyrplugin.vim, so keep the previous
-- <A-o>/<A-i> bindings on top of vim.treesitter.select().
vim.keymap.set({ "n", "x" }, "<A-o>", function() vim.treesitter.select("parent") end,
    { desc = "Expand selection to parent node" })
vim.keymap.set({ "n", "x" }, "<A-i>", function() vim.treesitter.select("child") end,
    { desc = "Shrink selection to child node" })

-- Start highlighting per buffer; core does not do it automatically
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("TreesitterHighlight", { clear = true }),
    callback = function(args)
        local stats = vim.uv.fs_stat(vim.api.nvim_buf_get_name(args.buf))
        if stats and stats.size > ts_max_filesize then
            return
        end
        -- install() runs asynchronously, so a parser can still be missing on a
        -- first run; start() raises rather than returning false in that case.
        pcall(vim.treesitter.start, args.buf)
    end,
})

-- =============================================================================
-- nvim-treesitter-textobjects (main branch)
-- =============================================================================
-- Also module-free: setup() takes behaviour options only and every mapping is
-- declared explicitly. Only the function and class objects are mapped; the
-- movement maps the old config used (]m [m ]M [M ]] [[ ][ []) are already Vim
-- motions, ]s/[s ]z/[z ]i/[i are built-ins for spell, folds and includes, and
-- [o/]o belong to vim-unimpaired's option toggles. `as` is "a sentence".
require("nvim-treesitter-textobjects").setup({
    select = {
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        selection_modes = {
            ["@function.outer"] = "V", -- linewise
            ["@class.outer"] = "<c-v>", -- blockwise
        },
        -- Extend any textobject to include surrounding whitespace, like `ap`
        include_surrounding_whitespace = true,
    },
})

local ts_select = require("nvim-treesitter-textobjects.select")

local ts_textobjects = {
    { "af", "@function.outer", "Select outer part of a function region" },
    { "if", "@function.inner", "Select inner part of a function region" },
    { "ac", "@class.outer",    "Select outer part of a class region" },
    { "ic", "@class.inner",    "Select inner part of a class region" },
}
for _, obj in ipairs(ts_textobjects) do
    local lhs, query, desc = obj[1], obj[2], obj[3]
    vim.keymap.set({ "x", "o" }, lhs, function()
        ts_select.select_textobject(query, "textobjects")
    end, { desc = desc })
end

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

-- =============================================================================
-- agentic
-- =============================================================================
-- Monkey-patch vim.notify to be async-safe
vim.notify = vim.schedule_wrap(vim.notify)

require("agentic").setup({
    provider ="gemini-acp",
    acp_providers = {
        ["gemini-acp"] = {
            env = {
                GOOGLE_CLOUD_PROJECT = os.getenv("GOOGLE_CLOUD_PROJECT"),
            },
        },
    },
})
vim.keymap.set({"n", "v", "i"}, "<leader>ai", function() require("agentic").toggle() end, { desc = 'Toggle Agentic Chat' })
vim.keymap.set({"n", "v", "i"}, "<leader>aia", function() require("agentic").add_selection_or_file_to_context() end, { desc = 'Add file or selection to Agentic to Context' })
vim.keymap.set({"n", "v", "i"}, "<leader>air", function() require("agentic").new_session() end, { desc = 'New Agentic Sssion' })

-- Sync Neovim yank/paste register with the system clipboard
vim.opt.clipboard = "unnamedplus"

-- Tell Neovim to use native OSC 52 terminal sequences for clipboard operations
vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
        ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
        ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
        ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
        ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    },
}
