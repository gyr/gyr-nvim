local gyr_group = vim.api.nvim_create_augroup("Gyr", { clear = true })

-- Insert Mode list / relativenumber overrides
vim.api.nvim_create_autocmd("InsertEnter", {
    group = gyr_group,
    pattern = "*",
    callback = function()
        vim.opt_local.list = true
        vim.opt_local.linebreak = false
        if vim.opt_local.number:get() then
            vim.opt_local.relativenumber = false
        end
    end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
    group = gyr_group,
    pattern = "*",
    callback = function()
        vim.opt_local.paste = false
        vim.opt_local.list = false
        vim.opt_local.linebreak = true
        if vim.opt_local.number:get() then
            vim.opt_local.relativenumber = true
        end
    end,
})

-- Return to last edit position
vim.api.nvim_create_autocmd("BufReadPost", {
    group = gyr_group,
    pattern = "*",
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
            vim.cmd("normal! zvzz")
        end
    end,
})

-- =============================================================================
-- YANK HIGHLIGHT
-- =============================================================================
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight yanked text",
    callback = function()
        vim.hl.on_yank({ higroup = "Visual", timeout = 300 })
    end,
})
