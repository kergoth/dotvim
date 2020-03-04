if !exists('g:loaded_ale')
  finish
endif

scriptencoding utf-8

" Error and warning signs
let g:ale_sign_error = '⤫'
let g:ale_sign_warning = '⚠'

let g:ale_linters = {
\   'python': ['flake8', 'mypy'],
\   'sh': ['shellcheck'],
\}

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'vim': ['remove_trailing_lines'],
\   'python': ['isort', 'autopep8'],
\   'sh': ['shfmt'],
\   'go': ['gofmt'],
\   'elixir': ['mix_format'],
\}

let g:ale_sh_shfmt_options = '-ci -bn -i 4'

" Bind <leader>f to fixing/formatting with ALE
nmap <leader>f <Plug>(ale_fix)

augroup after_plugin_ale
  autocmd!
  " Run gofmt on save
  autocmd FileType go let b:ale_fix_on_save = 1
augroup END
