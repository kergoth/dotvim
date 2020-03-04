if !exists('g:loaded_matchit')
  finish
endif

augroup after_plugin_matchit
  autocmd!
  autocmd FileType make let b:match_words='\<ifndef\>\|\<ifdef\>\|\<ifeq\>\|\<ifneq\>:\<else\>:\<endif\>'
augroup END
