scriptencoding utf-8

function! vimrc#quickfix#format()
  let qflist = map(getqflist(),
        \ 'extend(v:val, {"filename" : bufname(v:val.bufnr)})')

  let prefix_len = 2 + max(map(copy(qflist),
        \ 'strchars(v:val.filename . v:val.lnum)'))

  let fmt = '%-' . prefix_len . 's' . '%s'

  setlocal modifiable

  call setline('1', map(qflist,
        \ 'printf(fmt, v:val.filename . ":" . v:val.lnum, "│ " . v:val.text)'))

  setlocal nomodifiable nomodified
endfunction
