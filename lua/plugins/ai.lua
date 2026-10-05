-- =============================================================================
-- AI: agentic
-- =============================================================================
-- Monkey-patch vim.notify to be async-safe
vim.notify = vim.schedule_wrap(vim.notify)

require("agentic").setup({
    provider = "gemini-acp",
    acp_providers = {
        ["gemini-acp"] = {
            env = {
                GOOGLE_CLOUD_PROJECT = os.getenv("GOOGLE_CLOUD_PROJECT"),
            },
        },
    },
})
-- Use 'x' (Visual only) instead of 'v' (Visual + Select) to avoid breaking snippet placeholders in Select mode
vim.keymap.set({ "n", "x", "i" }, "<leader>ai", function()
    require("agentic").toggle()
end, { desc = "Toggle Agentic Chat" })
vim.keymap.set({ "n", "x", "i" }, "<leader>aia", function()
    require("agentic").add_selection_or_file_to_context()
end, { desc = "Add file or selection to Agentic to Context" })
vim.keymap.set({ "n", "x", "i" }, "<leader>air", function()
    require("agentic").new_session()
end, { desc = "New Agentic Session" })
