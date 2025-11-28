Installation:
```
git clone --recursive git://github.com/gyr/dotnvim.git ~/.config/nvim
```


Installing plugins:
```
PLUGINS="http://github.com/ashen-org/ashen.nvim.git
  http://github.com/Saghen/blink.cmp.git
  http://github.com/stevearc/conform.nvim.git
  http://github.com/ibhagwan/fzf-lua.git
  http://github.com/lukas-reineke/indent-blankline.nvim.git
  http://github.com/brennovich/marques-de-itu.git
  http://github.com/neovim/nvim-lspconfig.git
  http://github.com/nvim-treesitter/nvim-treesitter-context.git
  http://github.com/nvim-treesitter/nvim-treesitter.git
  http://github.com/nvim-treesitter/nvim-treesitter-textobjects.git
  http://github.com/rachartier/tiny-glimmer.nvim.git
  http://github.com/andreasvc/vim-256noir.git
  http://github.com/tpope/vim-fugitive.git
  http://github.com/mhinz/vim-signify.git
  http://github.com/tpope/vim-unimpaired.git
  http://github.com/vimwiki/vimwiki.git"
  
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
