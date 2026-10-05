-- Sync Neovim yank/paste register with the system clipboard
vim.opt.clipboard = "unnamedplus"

-- Tell Neovim to use native OSC 52 terminal sequences for clipboard operations
vim.g.clipboard = {
    name = "OSC 52",
    copy = {
        ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
        ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
        ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
        ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
}

-- Copy file path / selection reference for pasting in to AI chats
local function copy_ref(opts)
    --"%" is the current buffer's file name; ":." makes it relative to cwd
    local path = vim.fn.expand("%:.")
    if path == "" then
        vim.notify("No file path available for current buffer", vim.log.levels.WARN)
        return
    end

    -- ref is what ends up in the clipboard; start with just the path
    local ref = path
    if opts.visual then
        -- Exit visual mode synchronously to update the '< and '> marks and clean up the UI
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", true)
        local start_line = vim.fn.line("'<")
        local end_line = vim.fn.line("'>")
        -- append the range, e.g. "lua/config/keymaps.lua:1:23"
        ref = path .. ":" .. start_line .. ":" .. end_line
    end

    -- ask for an optional free-text note on the command line (Enter to skip)
    local note = vim.fn.input("Prompt (optional): ")
    if note ~= "" then
        -- append the note after the ref, separated by a space
        ref = ref .. " " .. note
    end

    -- write ref into the "+" register, which is the system clipboard
    vim.fn.setreg("+", ref)
    -- show a confirmation message with what was copied
    vim.notify("Copied: " .. ref, vim.log.levels.INFO)
end

vim.keymap.set("n", "<leader>aic", function()
    copy_ref({})
end, { desc = "Copy path for AI agent" })
vim.keymap.set("x", "<leader>aic", function()
    copy_ref({ visual = true })
end, { desc = "Copy path with line range for AI agent" })
