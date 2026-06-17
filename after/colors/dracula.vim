call vimrc#statusline#set_colors({
      \ 'User1': {'Comment': {'override': 'gui=reverse cterm=reverse guibg=white ctermbg=white'}},
      \ 'User2': {'Number': {'override': 'gui=reverse cterm=reverse guibg=black ctermbg=black'}},
      \ 'User3': {'StatusLine': {'copy': 'ctermfg guifg'}, 'Identifier': {'copy': 'ctermfg guifg'}},
      \ })
