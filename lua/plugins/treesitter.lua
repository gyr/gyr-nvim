-- =============================================================================
-- nvim-treesitter (main branch)
-- =============================================================================
-- The `main` rewrite removed the module system: setup() only reads `install_dir`,
-- so `ensure_installed`, `highlight`, `incremental_selection` and `textobjects`
-- are no longer honoured. Parsers are installed with install(); highlighting is
-- provided by Neovim core and must be started per buffer.
-- See :h treesitter-highlight and the plugin README.
local ts_parsers = {
    "bash",
    "dockerfile",
    "go",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "vim",
    "xml",
    "yaml",
}

-- Asynchronous, and a no-op for parsers that are already present
require("nvim-treesitter").install(ts_parsers)

-- Skip treesitter highlighting on large files (replaces `highlight.disable`)
local ts_max_filesize = 100 * 1024 -- 100 KB

-- Incremental selection. Core provides an/in/]n/[n/]N/[N
-- (:h treesitter-incremental-selection), but an/in are shadowed by the
-- NextTextObject mappings in after/plugin/gyrplugin.vim, so keep the previous
-- <A-o>/<A-i> bindings on top of vim.treesitter.select().
vim.keymap.set({ "n", "x" }, "<A-o>", function()
    vim.treesitter.select("parent")
end, { desc = "Expand selection to parent node" })
vim.keymap.set({ "n", "x" }, "<A-i>", function()
    vim.treesitter.select("child")
end, { desc = "Shrink selection to child node" })

-- Start highlighting per buffer; core does not do it automatically
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("TreesitterHighlight", { clear = true }),
    callback = function(args)
        local stats = vim.uv.fs_stat(vim.api.nvim_buf_get_name(args.buf))
        if stats and stats.size > ts_max_filesize then
            return
        end
        -- install() runs asynchronously, so a parser can still be missing on a
        -- first run; start() raises rather than returning false in that case.
        pcall(vim.treesitter.start, args.buf)
    end,
})


-- folding with treesitter:
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99 -- start with folds open
