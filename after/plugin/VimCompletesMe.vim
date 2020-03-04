if !exists('g:loaded_VimCompletesMe')
  finish
endif

augroup after_plugin_VimCompletesMe
  autocmd!
  autocmd FileType vim let b:vcm_tab_complete = 'vim'
augroup END

