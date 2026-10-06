-- =============================================================================
-- LSP: lspconfig
-- =============================================================================
-- This function defines actions/keymaps that run when *any* LSP client attaches.
local on_attach = function(client, bufnr)
    -- Disable features on specific servers to manage conflicts
    if client.name == "pyright" then
        -- Pyright's formatting is disabled to defer to conform.nvim
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    elseif client.name == "ruff" then
        -- Ruff's core purpose is linting/fixes, so disable things Pyright handles better
        -- like hover/completion if they cause conflicts or visual clutter.
        client.server_capabilities.hoverProvider = false
        -- Note: Ruff does not provide completion, so no need to disable that.
    end

    -- Buffer-local keymaps for LSP features
    local function map(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { noremap = true, silent = true, buffer = bufnr, desc = desc })
    end
    map("gd", vim.lsp.buf.definition, "Go to definition")
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
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("LspConfigPython", { clear = true }),
    callback = function(args)
        on_attach(vim.lsp.get_client_by_id(args.data.client_id), args.buf)
    end,
})

-- A. Configure Pyright (Core LSP and Type Checking)
-- We override the default config provided by nvim-lspconfig
vim.lsp.config("pyright", {
    -- We attach the general on_attach function via the Autocommand above
    settings = {
        python = {
            analysis = {
                -- Crucial: Disable general linting in Pyright to use Ruff instead
                ignore = { "*" },
                typeCheckingMode = "strict",
            },
        },
        pyright = {
            -- Disable Pyright's auto-organize to let Ruff handle it
            disableOrganizeImports = true,
        },
    },
})

-- B. Configure Ruff (Real-time Linting and Fixes)
-- We attach the general on_attach function via the Autocommand above
vim.lsp.config("ruff", {
    -- Ruff server is configured by nvim-lspconfig to run the 'ruff server' command
    init_options = {
        -- Ruff-specific settings can go here if needed
        logLevel = "warning",
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
            analyses = { unusedparams = true },
            staticcheck = true,
        },
    },
})

vim.lsp.config("rust_analyzer", {
    settings = {
        ["rust-analyzer"] = {
            cargo = { features = "all" },
            check = { command = "clippy" },
        },
    },
})

vim.lsp.enable("pyright")
vim.lsp.enable("ruff")
vim.lsp.enable("lua_ls")
vim.lsp.enable("gopls")
vim.lsp.enable("rust_analyzer")

-- =============================================================================
-- Highlight the element under cursor
-- =============================================================================
vim.api.nvim_create_autocmd({ "CursorHold" }, {
    buffer = bufnr, -- current buffer number
    callback = function()
        vim.lsp.buf.document_highlight()
    end,
})

vim.api.nvim_create_autocmd({ "CursorMoved" }, {
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
