if !exists('g:loaded_neosnippet')
  finish
endif

" Next completion, expand snippet, or open the completion menu
imap <expr><Tab>
      \ pumvisible() ?
      \   "\<Plug>vim_completes_me_forward" :
      \   neosnippet#expandable_or_jumpable() ?
      \     "\<Plug>(neosnippet_expand_or_jump)" :
      \     "\<Plug>vim_completes_me_forward"

" Next snippet placeholder
smap <expr><Tab>
      \ neosnippet#expandable_or_jumpable() ?
      \   "\<Plug>(neosnippet_expand_or_jump)" :
      \   "\<Tab>"

imap <expr><C-l>
      \ neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)" : "\<C-n>"

" Previous completion
imap <S-Tab> <Plug>vim_completes_me_backward

" Explicit snippet expansion
imap <c-k> <Plug>(neosnippet_expand_or_jump)
smap <c-k> <Plug>(neosnippet_expand_or_jump)
xmap <c-k> <Plug>(neosnippet_expand_target)

" Expand the completed snippet or accept the selected completion with <cr>
" Adjusted to support endwise
imap <expr><cr>
      \ pumvisible() ?
      \   neosnippet#expandable() ?
      \     "\<Plug>(neosnippet_expand)" :
      \     "\<c-y>" :
      \   "\<cr>\<Plug>DiscretionaryEnd"

" Delete snippet markers when leaving insert mode
augroup neosnippet
  autocmd!
  autocmd InsertLeave * NeoSnippetClearMarkers
augroup END
