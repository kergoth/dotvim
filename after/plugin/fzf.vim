if !exists('g:loaded_fzf')
  finish
endif

" Fzf binds
if !exists('g:fzf_command_prefix')
  let g:fzf_command_prefix = ''
endif

if exists(':' . g:fzf_command_prefix . 'Buffers')
  exe 'nnoremap <silent> <C-b> :' . g:fzf_command_prefix . 'Buffers<CR>'
endif
if exists(':' . g:fzf_command_prefix . 'Files')
  exe 'nnoremap <silent> <C-p> :' . g:fzf_command_prefix . 'Files<CR>'
endif
