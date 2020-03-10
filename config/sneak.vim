let g:sneak#label = 1
let g:sneak#map_netrw = 0
let g:sneak#s_next = 1
let g:sneak#use_ic_scs = 1

nmap <Plug>(no_sneak_;) <Plug>Sneak_;
nmap <Plug>(no_sneak_,) <Plug>Sneak_,

function! s:Load() abort
  packadd vim-sneak
  nmap s <Plug>Sneak_s
  nmap S <Plug>Sneak_S
  omap z <Plug>Sneak_s
  omap Z <Plug>Sneak_S
  xmap s <Plug>Sneak_s
  xmap Z <Plug>Sneak_S
endfunction

nnoremap <silent> s :call <SID>Load() \| call sneak#wrap('', 2, 0, 2, 1)<CR>
nnoremap <silent> S :call <SID>Load() \| call sneak#wrap('', 2, 1, 2, 1)<CR>
xnoremap <silent> s :call <SID>Load() \| call sneak#wrap(visualmode(), 2, 0, 2, 1)<CR>
xnoremap <silent> Z :call <SID>Load() \| call sneak#wrap(visualmode(), 2, 1, 2, 1)<CR>
onoremap <silent> z :call <SID>Load() \| call sneak#wrap(v:operator, 2, 0, 2, 1)<CR>
onoremap <silent> Z :call <SID>Load() \| call sneak#wrap(v:operator, 2, 1, 2, 1)<CR>
