local vimrc = vim.fn.stdpath("config") .. "/vimrc.vim"
vim.cmd.source(vimrc)

-- vim.cmd("colorscheme ashen")
require("ashen").load()

--require'lspconfig'.pylsp.setup{}

-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspconfig = require('lspconfig')

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 'pyright', 'lua_ls' }
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        -- on_attach = my_custom_on_attach,
        capabilities = capabilities,
    }
end

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
    mapping = cmp.mapping.preset.insert({
        ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
        ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
        -- C-b (back) C-f (forward) for snippet placeholder navigation.
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    sources = {
        { name = 'nvim_lsp' },
    },
}


-- terminal
local function open_bottom_terminal(height)
  vim.cmd("botright split term://bash")
  local terminal_win = vim.api.nvim_get_current_win() -- Get the terminal window
  vim.api.nvim_win_set_height(terminal_win, height)
  vim.cmd("wincmd j") -- Move focus back to the original window
end

vim.api.nvim_create_user_command('BottomTerm', function(args)
  local height = tonumber(args.args) or 10
  open_bottom_terminal(height)
end, { nargs = '?' })

vim.keymap.set("n", "<leader>t", ":BottomTerm<CR>")

vim.keymap.set("n", "<leader>n", ":e ~/.config/nvim/init.lua<CR>")
