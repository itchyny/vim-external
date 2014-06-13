# Switch to external applications
You can open

* the external editor with `<Plug>(external-editor)`.
* the external explorer with `<Plug>(external-explorer)`.
* the external browser with `<Plug>(external-browser)`.

## Example Settings
You can use the following settings to open the external applications quickly.

```vim
map <Leader>e <Plug>(external-editor)
map <Leader>n <Plug>(external-explorer)
map <Leader>b <Plug>(external-browser)
```

## Author
itchyny (https://github.com/itchyny)

## License
This software is released under the MIT License, see LICENSE.

## Installation
### Manually
1. Put all the files under $VIM/

### pathogen-vim (https://github.com/tpope/vim-pathogen)
1. Execute the following command.

        git clone https://github.com/itchyny/vim-external ~/.vim/bundle/vim-external

### Vundle (https://github.com/gmarik/Vundle.vim)
1. Add the following configuration to your vimrc.

        Plugin 'itchyny/vim-external'

2. Install with `:PluginInstall`.

### NeoBundle (https://github.com/Shougo/neobundle.vim)
1. Add the following configuration to your vimrc.

        NeoBundle 'itchyny/vim-external'

2. Install with `:NeoBundleInstall`.

