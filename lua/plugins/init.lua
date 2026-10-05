-- =============================================================================
-- PLUGIN MANAGEMENT: vim.pack (Neovim 0.12)
-- =============================================================================
vim.pack.add({
    "https://github.com/Saghen/blink.lib", -- Required by blink.cmp v2
    "https://github.com/Saghen/blink.cmp",
    "https://github.com/stevearc/conform.nvim",
    "https://github.com/ibhagwan/fzf-lua",
    "https://github.com/lukas-reineke/indent-blankline.nvim",
    "https://github.com/brennovich/marques-de-itu",
    -- Supplies the lsp/*.lua definitions (cmd, filetypes, root_markers) that
    -- vim.lsp.config()/vim.lsp.enable() below extend. Without it no server starts.
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/lewis6991/gitsigns.nvim",
    "https://github.com/vimwiki/vimwiki",
    "https://github.com/carlos-algms/agentic.nvim",
    "https://github.com/nvim-lualine/lualine.nvim",
})

require("plugins.completions")
require("plugins.lsp")
require("plugins.vimwiki")
require("plugins.colorscheme")
require("plugins.formatting")
require("plugins.treesitter")
require("plugins.git")
require("plugins.statusline")
require("plugins.ai")
require("plugins.indenting")
require("plugins.fzf")
