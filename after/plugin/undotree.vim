if !exists('g:loaded_undotree')
  finish
endif

let g:undotree_SetFocusWhenToggle = 1
let g:undotree_WindowLayout = 2

nmap <leader>u :UndotreeToggle<CR>
