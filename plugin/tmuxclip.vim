" Trivial vim global plugin to ease interaction with the tmux buffers
" Last Change:	2020 Mar 27
" Maintainer:	Christopher Larson <kergoth@gmail.com>
" License:	This file is placed under the Vim license.

if exists('g:loaded_tmuxclip')
  finish
endif
let g:loaded_tmuxclip = 1

function! YankToTmux(type, ...)
  let sel_save = &selection
  let &selection = 'inclusive'
  let reg_save = @@

  if a:0  " Invoked from Visual mode, use gv command.
    silent exe 'normal! gvy'
  elseif a:type ==# 'line'
    silent exe "normal! '[V']y"
  else
    silent exe 'normal! `[v`]y'
  endif

  call system('tmux load-buffer -', @@)

  let &selection = sel_save
  let @@ = reg_save
endfunction

nmap <silent> ,ty :set opfunc=YankToTmux<CR>g@
vmap <silent> ,ty :<C-U>call YankToTmux(visualmode(), 1)<CR>

nmap ,tp :read !tmux show-buffer<CR>
