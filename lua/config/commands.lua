-- remove plugins from disk that are no longer in vim.pack.add() specs
vim.api.nvim_create_user_command("PackClean", function()
    local inactive = vim.iter(vim.pack.get())
        :filter(function(x)
            return not x.active
        end)
        :map(function(x)
            return x.spec.name
        end)
        :totable()
    if #inactive == 0 then
        vim.notify("No inactive plugins to remove", vim.log.levels.INFO)
        return
    end
    vim.pack.del(inactive)
    vim.notify("Removed: " .. table.concat(inactive, ", "), vim.log.levels.INFO)
end, { desc = "Remove plugins not in vim.pack.add() specs" })

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

vim.keymap.set("n", "<leader>t", ":BottomTerm<CR>", { desc = "Open terminal at the botton" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })


-- =============================================================================
-- show unsaved diff
-- =============================================================================
vim.api.nvim_create_user_command(
    "DiffOrig",
    "vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis | wincmd p | diffthis",
    { desc = "Diff current buffer against original file on disk" }
)
