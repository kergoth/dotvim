if !exists('g:loaded_dirvish')
  finish
endif

augroup after_plugin_dirvish
  autocmd!
  " dirvish: map `gr` to reload.
  autocmd FileType dirvish nnoremap <silent><buffer>
        \ gr :<C-U>Dirvish %<CR>

  " dirvish: map `gh` to hide dot-prefixed files.  Press `R` to "toggle" (reload).
  autocmd FileType dirvish nnoremap <silent><buffer>
        \ gh :silent keeppatterns g@\v/\.[^\/]+/?$@d _<cr>:setl cole=3<cr>

  " Let ,C also close the dirvish window, from that window
  autocmd FileType dirvish nnoremap <silent><buffer> ,wC <Plug>(dirvish_quit)
augroup END
