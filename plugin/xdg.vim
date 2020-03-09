" xdg.vim
"  Author:      Chris Larson <kergoth@gmail.com>
"  Date:        2020-03-03
"  Description: Use XDG paths to align with neovim.

if exists('g:loaded_xdg')
  finish
endif
let g:loaded_xdg = 1

if empty($XDG_DATA_HOME)
  let $XDG_DATA_HOME = $HOME . '/.local/share'
endif

if !has('nvim')
  " Remove default tempdir paths in favor of the XDG paths
  let s:save_backupdir = &backupdir
  let s:save_directory = &directory
  set backupdir& directory&
  if &backupdir ==# s:save_backupdir
    set backupdir=.
  endif
  if &directory ==# s:save_directory
    set directory=.
  endif
  let &backupdir = s:save_backupdir
  let &directory = s:save_directory

  set backupdir+=$XDG_DATA_HOME/vim/backup
  set directory+=$XDG_DATA_HOME/vim/swap
  if has('persistent_undo')
    set undodir+=$XDG_DATA_HOME/vim/undo
  endif
  set viewdir=$XDG_DATA_HOME/vim/view

  let g:netrw_home = $XDG_DATA_HOME . '/vim'
else
  let g:netrw_home = $XDG_DATA_HOME . '/nvim'
endif
