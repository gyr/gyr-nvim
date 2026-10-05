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
vim.keymap.set("n", "<leader>Q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
