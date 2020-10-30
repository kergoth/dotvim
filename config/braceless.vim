if v:version >= 800
  " vint: -ProhibitAutocmdWithNoGroup
  autocmd FileType python,yaml packadd braceless.vim | BracelessEnable +indent +fold
endif

" BraceLess Functions - create folds for the functions
autocmd User BracelessEnabled_python nnoremap <buffer> <silent> ,bld :%g/\<def\>/norm zc<cr>
" BraceLess Classes - create folds for the classes
autocmd User BracelessEnabled_python nnoremap <buffer> <silent> ,blc :%g/\<class\>/norm zc<cr>
" BraceLess All - switch to the slow fold method to create them all
autocmd User BracelessEnabled_python nnoremap <buffer> <silent> ,bla :BracelessEnable +fold-slow<cr>

" Adjust my space mapping to trigger Braceless' fold creation
autocmd User BracelessEnabled_python,BracelessEnabled_yaml nmap <buffer> <silent> <expr> <Space> foldlevel('.') ? "za" : "zc"
