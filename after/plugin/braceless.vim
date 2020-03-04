if !exists('g:loaded_braceless')
  finish
endif

augroup after_plugin_braceless
  autocmd!

  autocmd FileType python BracelessEnable +indent +fold
  autocmd FileType yaml BracelessEnable +indent +fold

  " BraceLess Functions - create folds for the functions
  autocmd FileType python nnoremap <buffer> <silent> <leader>bld :%g/\<def\>/norm zc<cr>
  " BraceLess Classes - create folds for the classes
  autocmd FileType python nnoremap <buffer> <silent> <leader>blc :%g/\<class\>/norm zc<cr>
  " BraceLess All - switch to the slow fold method to create them all
  autocmd FileType python nnoremap <buffer> <silent> <leader>bla :BracelessEnable +fold-slow<cr>

  " Adjust my space mapping to trigger Braceless' fold creation
  autocmd FileType python nmap <buffer> <silent> <expr> <Space> foldlevel('.') ? "za" : "zc"
  autocmd FileType yaml nmap <buffer> <silent> <expr> <Space> foldlevel('.') ? "za" : "zc"
augroup END
