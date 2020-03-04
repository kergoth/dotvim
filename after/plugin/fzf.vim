if !exists('g:loaded_fzf')
  finish
endif

" Fzf binds
nnoremap <silent> <C-b> :FZFBuffers<cr>
nnoremap <silent> <C-p> :FZFFiles<cr>
