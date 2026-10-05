-- =============================================================================
-- GIT: gitsigns
-- =============================================================================
-- require("gitsigns").setup()
require("gitsigns").setup({
    on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- ==========================================
        -- 1. HUNK NAVIGATION (Standard ]c and [c)
        -- ==========================================
        map("n", "]c", function()
            if vim.wo.diff then
                vim.cmd.normal({ "]c", bang = true })
            else
                gitsigns.nav_hunk("next")
            end
        end, { desc = "Next Hunk" })

        map("n", "[c", function()
            if vim.wo.diff then
                vim.cmd.normal({ "[c", bang = true })
            else
                gitsigns.nav_hunk("prev")
            end
        end, { desc = "Prev Hunk" })

        -- ==========================================
        -- 2. INSPECTION AND UTILITIES
        -- ==========================================
        -- Preview Hunk (Shows diff of current hunk in a floating window)
        map("n", "<leader>gd", gitsigns.preview_hunk, { desc = "Preview Hunk" })

        -- Blame (Inspect author & commit message of current line)
        map("n", "<leader>gb", function()
            gitsigns.blame_line({ full = true })
        end, { desc = "Blame Line" })
        -- map("n", "<leader>gb", gitsigns.toggle_current_line_blame, { desc = "Toggle Line Blame" })

        -- Diffing (Open standard diff split comparing file to index)
        -- map("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff This" })
        -- map("n", "<leader>hD", function()
        --     gitsigns.diffthis("~")
        -- end, { desc = "Diff This (~)" })

        -- Toggle displaying deleted lines as virtual text inline
        -- map("n", "<leader>td", gitsigns.toggle_deleted, { desc = "Toggle Deleted" })

        -- ==========================================
        -- 4. HUNK TEXT OBJECT (ih)
        -- ==========================================
        -- Lets you do things like `v_ih` (select current hunk) or `d_ih` (delete current hunk)
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select Hunk" })
    end,
})
