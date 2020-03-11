augroup plugin_lint
  autocmd!
  autocmd FileType vim let b:linter = 'vint' | let b:lint_on_write = 1 | let b:lint_on_read = 1
  autocmd FileType text let b:linter = 'echo' | let b:lint_on_write = 1 | let b:lint_on_read = 1
  autocmd BufWritePost * if get(b:, 'lint_on_write', 0) == 1 | exe ':Lint' | endif
  autocmd BufReadPost * if get(b:, 'lint_on_read', 0) == 1 | exe ':Lint' | endif
augroup END
 
command! -nargs=? -bang Lint call vimrc#compiler#lint("<bang>", <f-args>)
command! -nargs=? -bang Compile call vimrc#compiler#compilemake("<bang>", <f-args>)
