-- =============================================================================
-- AUTO-COMPLETIOTN: blink
-- =============================================================================
vim.opt.completeopt = { "fuzzy", "menu", "menuone", "noselect" }

local blink = require("blink.cmp")
blink.setup({
    -- Display a preview of the selected item on the current line
    completion = {
        -- 'prefix' will fuzzy match on the text before the cursor
        -- 'full' will fuzzy match on the text before _and_ after the cursor
        -- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
        keyword = { range = "full" },

        -- Don't select by default, auto insert on selection
        list = { selection = { preselect = false, auto_insert = true } },

        menu = {
            draw = {
                treesitter = { "lsp" },
            },
        },

        -- Show documentation when selecting a completion item
        -- C-space: Open menu or open docs if already open
        documentation = { auto_show = true, auto_show_delay_ms = 500 },

        -- Display a preview of the selected item on the current line
        ghost_text = { enabled = true },
    },
    keymap = {
        preset = "default",

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

    -- Use a preset for snippets, check the snippets documentation for more information
    -- snippets = { preset = "default" | "luasnip" | "mini_snippets" },

    -- Experimental signature help support
    signature = { enabled = true },

    -- Use high-performance Rust fuzzy matcher with typo resistance, falling back to Lua if needed
    fuzzy = { implementation = "prefer_rust" },
})

-- 1. Generate capabilities with blink.cmp
local capabilities = require("blink.cmp").get_lsp_capabilities()

-- 2. Register capabilities globally FIRST
vim.lsp.config("*", { capabilities = capabilities })

