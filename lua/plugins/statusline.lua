-- =============================================================================
-- STATUSLINE: lualine
-- =============================================================================
require("lualine").setup({
    options = {
        theme = "auto", -- automatically matches your colorscheme
        component_separators = { left = "", right = "│" },
        section_separators = { left = "", right = "" },
    },
})
