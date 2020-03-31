if !exists('g:loaded_qf')
  finish
endif

let g:qf_auto_open_quickfix = 1
let g:qf_auto_open_loclist = 1
let g:qf_auto_resize = 1

nmap ,wc <Plug>(qf_qf_toggle)
nmap ,wl <Plug>(qf_loc_toggle)
