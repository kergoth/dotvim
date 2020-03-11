function! vimrc#compiler#lint(bang, ...) abort
  if len(a:000) == 1
    let l:linter = a:000[0]
  else
    let l:linter = get(b:, 'linter', '')
    if l:linter ==# ''
      echomsg 'Error: no linter specified, either pass it or set b:linter'
      return 1
    endif
  endif
  call vimrc#compiler#compilemake(a:bang, l:linter, "")
endfunction

function! vimrc#compiler#compilemake(bang, compiler, ...) abort
  let l:old_compiler = get(b:, 'current_compiler', '')
  exe 'compiler ' . a:compiler
  augroup compilemake
    au!
    autocmd QuickFixCmdPost [^l]* cclose
    autocmd QuickFixCmdPost    l* lclose
  augroup END
  try
    exe 'silent make' . a:bang . ' ' . join(a:000, ' ')
  catch
  finally
    au! compilemake
    if l:old_compiler !=# ''
      exe 'compiler ' . l:old_compiler
    else
      setl errorformat& makeprg&
      try
        unlet b:current_compiler
      catch
      endtry
    endif
  endtry
  redraw!
endfunction
