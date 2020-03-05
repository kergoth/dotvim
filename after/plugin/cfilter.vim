if !exists('g:loaded_cfilter')
  finish
endif

function! s:filter(bang, args)
    if len(getloclist(0)) != 0
        exe ':Lfilter' . a:bang . ' ' . a:args
    endif
    if len(getqflist()) != 0
        exe ':Cfilter' . a:bang . ' ' . a:args
    endif
endfunction

command! -bang -nargs=* Filter :call s:filter('<bang>', '<args>')
