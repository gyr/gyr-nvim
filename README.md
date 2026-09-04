Installation:
```
git clone --recursive git://github.com/gyr/dotnvim.git ~/.config/nvim
```

## Plugin Management (Neovim 0.12+ with vim.pack)

**Installing plugins:**
Launch nvim and plugins will be installed automatically on first run.

**Updating plugins:**
```vim
:lua vim.pack.update()
```

**Adding a plugin:**
Edit `init.lua` and add to the `vim.pack.add({ ... })` list, then reload Neovim.

**Removing a plugin:**
Remove from `init.lua` and run:
```vim
:lua vim.pack.del("plugin-name")
```

**Check plugin health:**
```vim
:checkhealth vim.pack
```

---

## Installed Plugins

- blink.lib - Required dependency for blink.cmp v2
- blink.cmp - Auto-completion
- conform.nvim - Formatting
- fzf-lua - Fuzzy finder
- indent-blankline.nvim - Indentation guides
- marques-de-itu - Color scheme
- nvim-lspconfig - LSP server definitions (cmd/filetypes/root_markers)
- nvim-treesitter - Syntax highlighting
- nvim-treesitter-context - Show context
- nvim-treesitter-textobjects - Text objects
- tiny-glimmer.nvim - Animations
- vim-fugitive - Git integration
- vim-signify - Git diff signs
- vim-unimpaired - Bracket mappings
- vimwiki - Wiki
- agentic.nvim - AI assistant
