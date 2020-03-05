function! vimrc#minpac#packages()
  packadd minpac

  call minpac#init({'package_name': 'bundle'})
  call minpac#add('k-takata/minpac', {'type': 'opt'})

  call minpac#add('ajh17/VimCompletesMe')
  call minpac#add('christoomey/vim-tmux-navigator')
  call minpac#add('ConradIrwin/vim-bracketed-paste')
  call minpac#add('dense-analysis/ale')
  call minpac#add('dhruvasagar/vim-zoom')
  call minpac#add('dracula/vim', {'name': 'dracula'})
  call minpac#add('junegunn/fzf')
  call minpac#add('junegunn/fzf.vim')
  call minpac#add('justinmk/vim-dirvish')
  call minpac#add('justinmk/vim-sneak')
  call minpac#add('kergoth/vim-bitbake')
  call minpac#add('kergoth/vim-sh-indent', {'branch': 'indent-pipe-while'})
  call minpac#add('machakann/vim-highlightedyank')
  call minpac#add('mbbill/undotree')
  call minpac#add('romainl/vim-qlist')
  call minpac#add('sgur/vim-editorconfig')
  call minpac#add('sheerun/vim-polyglot')
  call minpac#add('tommcdo/vim-lion')
  call minpac#add('tpope/vim-abolish')
  call minpac#add('tpope/vim-apathy')
  call minpac#add('tpope/vim-commentary')
  call minpac#add('tpope/vim-dispatch')
  call minpac#add('tpope/vim-endwise')
  call minpac#add('tpope/vim-eunuch')
  call minpac#add('tpope/vim-obsession')
  call minpac#add('tpope/vim-repeat')
  call minpac#add('tpope/vim-rsi')
  call minpac#add('tpope/vim-surround')
  call minpac#add('tweekmonster/braceless.vim')
  call minpac#add('wellle/targets.vim')

  call minpac#add('roxma/nvim-yarp')
  call minpac#add('roxma/vim-hug-neovim-rpc')
  call minpac#add('Shougo/neosnippet.vim')
endfunction
