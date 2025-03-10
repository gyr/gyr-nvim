Installation:
```
git clone --recursive git://github.com/gyr/dotnvim.git ~/.config/nvim
```


Installing plugins:
```
PLUGINS=" http://github.com/dense-analysis/ale.git
  http://github.com/ashen-org/ashen.nvim.git
  http://github.com/junegunn/fzf.git
  http://github.com/junegunn/fzf.vim.git
  http://github.com/tpope/vim-fugitive.git
  http://github.com/neovim/nvim-lspconfig.git
  http://github.com/hrsh7th/nvim-cmp.git
  http://github.com/hrsh7th/cmp-nvim-lsp.git
  https://github.com/hrsh7th/cmp-buffer.git
  https://github.com/hrsh7th/cmp-cmdline.git
  https://github.com/hrsh7th/cmp-path.git
  http://github.com/mhinz/vim-signify.git"
  http://github.com/tpope/vim-unimpaired.git
  http://github.com/vimwiki/vimwiki.git
  https://github.com/nvim-treesitter/nvim-treesitter.git
  https://github.com/nvim-treesitter/nvim-treesitter-context.git
  https://github.com/nvim-treesitter/nvim-treesitter-textobjects.git
  https://github.com/lukas-reineke/indent-blankline.nvim.git
  
mkdir -p ~/.vim/pack/vendor/start
for i in ${PLUGINS}
do
    git -C ~/.vim/pack/vendor/start clone $i
done
```


Upgrading all plugins:
```
for i in $(ls ~/.vim/pack/vendor/start)
do
    pushd ~/.vim/pack/vendor/start/$i
    git fetch --prune --all
    git pull
    popd
done
```

Adding a plugin:
```
git -C ~/.vim/pack/vendor/start clone <git_repos_url>
```

Removing a plugin :
```
rm -rf ~/.vim/pack/vendor/start/<plugin_name>
```
