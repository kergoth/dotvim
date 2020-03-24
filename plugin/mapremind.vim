" Vim global plugin to remind the user of their mappings
" Last Change:	2020 Mar 12
" Maintainer:	Christopher Larson <kergoth@gmail.com>
" License:	This file is placed under the Vim license.
"
" This is a trivial reimplementation of vim-remembrall, with thanks.
" For example, it maps ,? to ;nmap ,

if exists('g:loaded_mapremind')
  finish
endif
let g:loaded_mapremind = 1

if !exists('g:mapremind_keys')
  let g:mapremind_keys = 'cdgyz][><=,\ '
endif
if !exists('g:mapremind_suffix')
  let g:mapremind_suffix = '?'
endif

for s:key in split(g:mapremind_keys, '\zs')
  if s:key ==# ' '
    let s:key = '<space>'
  endif
  for s:mode in ['n', 'x']
    if maparg(s:key . g:mapremind_suffix, s:mode) ==# ''
      if index(['<space>'], s:key) != -1
        exe printf('%snoremap %s%s :exe "%smap %s" . "%s"<CR>', s:mode, s:key, g:mapremind_suffix, s:mode, strcharpart(s:key, 0, 1), strcharpart(s:key, 1))
      else
        exe printf('%snoremap %s%s :%smap %s<CR>', s:mode, s:key, g:mapremind_suffix, s:mode, s:key)
      endif
    endif
  endfor
endfor
