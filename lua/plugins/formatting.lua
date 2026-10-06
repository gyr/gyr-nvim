-- =============================================================================
-- FORMATTING: conform
-- =============================================================================
local conform = require("conform")

conform.setup({
    -- Define Ruff Format as the dedicated formatter for Python
    formatters_by_ft = {
        python = { "ruff_format" },
        lua = { "stylua" },
        sh = { "shfmt" },
        perl = { "perltidy" },
        rust = { "rustfmt" },
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

-- Keymap for manual formatting (universal fallback to LSP if no external formatter exists)
vim.keymap.set({ "n", "x" }, "<leader>fmt", function()
    conform.format({
        -- Fall back to LSP formatting when no specific CLI tool is defined/available
        lsp_format = "fallback",
        -- Run synchronously: wait for format before returning control
        async = false,
        timeout_ms = 1000,
    })
end, { desc = "Format file or range (Conform/LSP)" })
