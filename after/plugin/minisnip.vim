if !exists('g:loaded_minisnip')
  finish
endif

let g:minisnip_dir = join(globpath(&runtimepath, 'minisnip/', 0, 1), ':')

imap <C-x><C-t> <Plug>(minisnip-complete)
inoremap <expr> <C-t> pumvisible() ?  "\<C-n>" : "\<C-t>"

" SuperTab like snippets behavior
imap <expr><Tab> pumvisible() ?
      \ "\<Plug>vim_completes_me_forward" :
      \     minisnip#ShouldTrigger() ?
      \     "\<Plug>(minisnip)" :
      \ "\<Tab>"
smap <expr><Tab> minisnip#ShouldTrigger() ?
      \ "\<Plug>(minisnip)"
      \: "\<Tab>"

" Next completion, expand snippet, or open the completion menu
imap <expr><Tab>
      \ pumvisible() ?
      \   "\<Plug>vim_completes_me_forward" :
      \   minisnip#ShouldTrigger() ?
      \     "\<Plug>(minisnip)" :
      \     "\<Plug>vim_completes_me_forward"

" Next snippet placeholder
smap <expr><Tab>
      \ minisnip#ShouldTrigger() ?
      \   "\<Plug>(minisnip)" :
      \   "\<Tab>"

imap <expr><C-l>
      \ minisnip#ShouldTrigger() ?
      \ "\<Plug>(minisnip)" : "\<C-n>"

" Previous completion
imap <S-Tab> <Plug>vim_completes_me_backward

" " Explicit snippet expansion
imap <c-k> <Plug>(minisnip)
smap <c-k> <Plug>(minisnip)
xmap <c-k> <Plug>(minisnip)

" Expand the completed snippet or accept the selected completion with <cr>
" Adjusted to support endwise
imap <expr><cr>
      \ pumvisible() ?
      \   minisnip#ShouldTrigger() ?
      \     "\<Plug>(minisnip)" :
      \     "\<c-y>" :
      \   "\<cr>\<Plug>DiscretionaryEnd"
