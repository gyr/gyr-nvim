-- =============================================================================
-- fzf-lua
-- =============================================================================
vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = "FZF for files in current dir" })
vim.keymap.set("n", "<leader>ffh", "<cmd>FzfLua files cwd=~/<cr>", { desc = "FZF for files in home dir" })
vim.keymap.set("n", "<leader>ffg", "<cmd>FzfLua files cwd=~/.gyr.d/<cr>", { desc = "FZF for files in gyr.d dir" })
vim.keymap.set("n", "<leader>ffs", "<cmd>FzfLua files cwd=~/.gyr.d/suse.d/<cr>", { desc = "FZF for files in suse dir" })
vim.keymap.set("n", "<leader>ffv", "<cmd>FzfLua files cwd=~/.config/nvim/<cr>", { desc = "FZF for files in nvim dir" })
vim.keymap.set("n", "<leader>fh", "<cmd>FzfLua oldfiles<cr>", { desc = "FZF for files in history" })

vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<cr>", { desc = "FZF for open buffers" })
vim.keymap.set("n", "<leader>fq", "<cmd>FzfLua quickfix<cr>", { desc = "FZF for quickfix list" })
vim.keymap.set("n", "<leader>fl", "<cmd>FzfLua blines<cr>", { desc = "FZF for current buffer line" })
vim.keymap.set("n", "<leader>ft", "<cmd>FzfLua treesitter<cr>", { desc = "FZF for treesitter symbols" })

vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<cr>", { desc = "FZF for file current project" })

vim.keymap.set("n", "<leader>flr", "<cmd>FzfLua lsp_references<cr>", { desc = "FZF for references" })
vim.keymap.set("n", "<leader>fli", "<cmd>FzfLua lsp_implementations<cr>", { desc = "FZF for implementations" })

vim.keymap.set("n", "<leader>fr", "<cmd>FzfLua registers<cr>", { desc = "FZF for registers" })
vim.keymap.set("n", "<leader>fk", "<cmd>FzfLua keymaps<cr>", { desc = "FZF for keymaps" })
vim.keymap.set("n", "<leader>fm", "<cmd>FzfLua marks<cr>", { desc = "FZF for marks" })
vim.keymap.set("n", "<leader>fj", "<cmd>FzfLua jumps<cr>", { desc = "FZF for jumps" })
