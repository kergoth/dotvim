let g:dracula_italic = 0
let g:statusline_dracula_colors = {
      \ 'User1': {'Comment': {'override': 'gui=reverse cterm=reverse guibg=white ctermbg=white'}},
      \ 'User2': {'Number': {'override': 'gui=reverse cterm=reverse guibg=black ctermbg=black'}},
      \ 'User3': {'StatusLine': {'copy': 'ctermfg guifg'}, 'Identifier': {'copy': 'ctermfg guifg'}},
      \ }

augroup colors_dracula
  autocmd!
  autocmd ColorScheme dracula call vimrc#statusline#set_colors(g:statusline_dracula_colors)
augroup END

if findfile('colors/dracula.vim', &runtimepath) !=# ''
  colorscheme dracula
endif
