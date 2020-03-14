" Filesystem paths {{{
let $MYVIMRC = expand('<sfile>:p')
let $VIMDOTDIR = fnamemodify($MYVIMRC, ':h')

" Load files from here, not elsewhere
set runtimepath^=$VIMDOTDIR runtimepath+=$VIMDOTDIR/after
if has('nvim')
  set runtimepath-=~/.config/nvim runtimepath-=~/.config/nvim/after
else
  set runtimepath-=~/.vim runtimepath-=~/.vim/after
endif
let &packpath = &runtimepath

" Do not write these next to the file
set backupdir-=.
set undodir-=.

" Double slash does not actually work for backupdir, here's a fix
augroup vimrc_backupdir
  au!
  au BufWritePre * let &backupext='@'.substitute(substitute(substitute(expand('%:p:h'), '/', '%', 'g'), '\', '%', 'g'), ':', '', 'g')
augroup END

" Ensure we cover all temp files for backup file creation
if $OSTYPE =~? 'darwin'
  set backupskip+=/private/tmp/*
endif
" }}}
" Defaults {{{
if v:version >= 800 && !has('nvim')
  unlet! skip_defaults_vim
  source $VIMRUNTIME/defaults.vim
else
  " Use version embedded in my dotvim
  runtime embedded/defaults.vim
endif
" }}}
" Encoding {{{
if has('multi_byte')
  if !has('nvim')
    " Termencoding will reflect the current system locale, but internally,
    " we use utf-8, and for files, we use whichever encoding from
    " &fileencodings was detected for the file in question.
    let &termencoding = &encoding
    set encoding=utf-8
    set fileencodings=ucs-bom,utf-8,default,latin1
  endif
  " Global fileencoding value is used for new files
  set fileencoding=utf-8
  scriptencoding utf-8
endif
" }}}
" General settings {{{
" Enable backup files
set backup

" These are of limited usefulness, as I write files often
set noswapfile

" I always run on journaled filesystems
set nofsync
try
  set swapsync=
catch
endtry

" Rename the file to the backup when possible.
set backupcopy=auto

" Viminfo file behavior
if has('viminfo') || has('shada')
  " f1  store file marks
  " '   # of previously edited files to remember marks for
  " :   # of lines of command history
  " /   # of lines of search pattern history
  " <   max # of lines for each register to be saved
  " s   max # of Kb for each register to be saved
  " h   don't restore hlsearch behavior
  set viminfo=f1,'1000,:1000,/1000,<1000,s100,h,r/tmp
  if !has('nvim')
    let &viminfo .= ',n' . $VIMINFO
  endif
endif

" Allow hiding buffers with modifications
set hidden

" Prompt me rather than aborting an action
set confirm

" Automatically reload files changed outside of vim
set autoread

" Navigate over visual lines
noremap j gj
noremap k gk
noremap gj j
noremap gk k

" Keep cursor in the same column when possible
set nostartofline

" Don't insert 2 spaces after the end of a sentence
set nojoinspaces

" Automatically write buffers on switch/make/exit
set autowrite
set autowriteall

" Kill annoying Press ENTER or type command to continue prompts
set shortmess=atIWocOTF

" Further reduce the Press ENTER prompts
set cmdheight=1

" Longer command/search history
set history=1000

if has('folding')
  " Default with all folds open
  set foldlevelstart=99
endif

" Make completion list behave more like a shell
set wildmode=list:longest

" Files we don't want listed
set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.DS_Store                       " OSX metadata
set wildignore+=*.luac                           " Lua byte code
set wildignore+=*.pyc,*.pyo                      " Python byte code

" Smart case handling for searches
set ignorecase
set smartcase

" Highlight my searches
set hlsearch

" Try to match case when using insert mode completion
set infercase

" Fast terminal, bump sidescroll to 1
set sidescroll=1

" Show columns of context when scrolling horizontally
set sidescrolloff=5

" Enable modelines
set modeline

" Persistent undo
if has('persistent_undo')
  set undofile
  set undolevels=5000
endif

" Always show the completion menu for the preview
set completeopt=longest,menuone,preview

" Search tools
if executable('rg')
  set grepprg=rg\ --smart-case\ --vimgrep\ $*
  command! -bang -nargs=* Search
        \ call fzf#vim#grep('rg --vimgrep --smart-case --color=always ' . shellescape(<q-args>), 1, <bang>0)
elseif executable('ag')
  set grepprg=ag\ -H\ --nocolor\ --nogroup\ --column\ $*
  command! -bang -nargs=* Search call fzf#vim#ag(<q-args>, 1, <bang>0)
elseif executable('ack')
  set grepprg=ack\ -H\ --nocolor\ --nogroup\ --column\ $*
  command! -bang -nargs=* Search
        \ call fzf#vim#grep('ack -H --nocolor --nogroup --column ' . shellescape(<q-args>), 1, <bang>0)
endif
set grepformat=%f:%l:%c:%m

" Ignore binary files matched with grep by default
set grepformat+=%-OBinary\ file%.%#

if has('multi_byte') && &encoding ==# 'utf-8'
  " Display of hidden characters
  set listchars=tab:»·,eol:¬,extends:❯,precedes:❮,nbsp:±

  " Show trailing whitespace this way if we aren't highlighting it in color
  if &t_Co < 3 && (! has('gui_running'))
    set listchars+=trail:·
  endif
endif

" Do soft word wrapping at chars in breakat
if has('linebreak')
  set linebreak
  try
    set breakindent
  catch
  endtry
  set cpoptions+=n
end

if &shell =~# 'fish'
  " Vim makes assumptions about shell behavior, so don't rely on $SHELL
  set shell=sh
elseif has('win32')
  " Enable dwrite support
  try
    set renderoptions=type:directx
  catch
  endtry
endif

" Prefer opening splits down and right rather than up and left
set splitbelow
set splitright

" Ignore changes in amount of whitespace
set diffopt+=iwhite

" Prefer the patience algorithm
if has('patch-8.1.0360')
  set diffopt+=internal,algorithm:patience
endif

augroup vimrc
  au!

  " Reload vimrc on save
  au BufWritePost $MYVIMRC nested source $MYVIMRC

  " Default to closed marker folds in my vimrc
  au BufRead $MYVIMRC setl fdm=marker | if &foldlevel == &foldlevelstart | setl foldlevel=0 | endif

  " Resize splits when the window is resized
  au VimResized * exe "normal! \<c-w>="

  " Automatically open, but do not go to (if there are errors) the quickfix /
  " location list window, or close it when is has become empty.
  "
  " Note: Must allow nesting of autocmds to enable any customizations for quickfix
  " buffers.
  autocmd QuickFixCmdPost [^l]* nested cwindow
  autocmd QuickFixCmdPost    l* nested lwindow

  " Adjust the quickfix window height to avoid unnecessary padding
  function! AdjustWindowHeight(minheight, maxheight)
    let l = 1
    let n_lines = 0
    let w_width = winwidth(0)
    while l <= line('$')
      " number to float for division
      let l_len = strlen(getline(l)) + 0.0
      let line_width = l_len/w_width
      let n_lines += float2nr(ceil(line_width))
      let l += 1
    endw
    exe max([min([n_lines, a:maxheight]), a:minheight]) . 'wincmd _'
  endfunction
  au FileType qf call AdjustWindowHeight(3, 10)

  " Close out the quickfix window if it's the only open window
  function! s:QuickFixClose()
    if &buftype ==# 'quickfix'
      " if this window is last on screen, quit
      if winnr('$') < 2
        quit
      endif
    endif
  endfunction
  au BufEnter * call <SID>QuickFixClose()

  " Close preview window when the completion menu closes
  autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

  " Unset paste on InsertLeave
  au InsertLeave * silent! set nopaste

  if exists('$TMUX')
    function! s:TmuxRename() abort
      if !exists('g:tmux_automatic_rename')
        let l:tmux_output = system('tmux show-window-options -v automatic-rename')
        if l:tmux_output ==# ''
          let l:tmux_output = system('tmux show-window-options -gv automatic-rename')
        endif
        try
          let g:tmux_automatic_rename = trim(l:tmux_output)
        catch
          let g:tmux_automatic_rename = split(l:tmux_output)[0]
        endtry
      endif
      return g:tmux_automatic_rename ==# 'on'
    endfunction

    au BufEnter * if s:TmuxRename() && empty(&buftype) | call system('tmux rename-window '.expand('%:t:S')) | endif
    au VimLeave * if s:TmuxRename() | call system('tmux set-window automatic-rename on') | endif
  endif

  " Expand the fold where the cursor lives
  autocmd BufWinEnter * silent! exe "normal! zv"

  " Automatically create missing directory
  function! s:MkNonExDir(file, buf) abort
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
      let dir=fnamemodify(a:file, ':h')
      if !isdirectory(dir)
        call mkdir(dir, 'p')
      endif
    endif
  endfunction
  autocmd BufWritePre,FileWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END
" }}}
" Indentation and formatting {{{
set formatoptions+=rn1j
set formatoptions-=t

" 4 space indentation by default
set shiftwidth=4
set softtabstop=4
set expandtab

" Copy indent from current line when starting a new line
set autoindent

" Copy structure of existing line's indent when adding a new line
set copyindent

" Wrap at column 78
set textwidth=78
" }}}
" Syntax and highlighting {{{

" Only highlight the first 200 characters of a line
set synmaxcol=200

" Colors red both trailing whitespace:
"  foo   
"  bar	
" And spaces before tabs:
"  foo 	bar
hi def link RedundantWhitespace Error
match RedundantWhitespace /\S\zs\s\+$\| \+\ze\t/

" We care quite a lot about the length of the git commit summary line
hi def link gitcommitOverflow Error

" Highlight our vim modeline
hi def link vimModeline Special
2match vimModeline /vim:\s*set[^:]\{-1,\}:/

" Fix the difficult-to-read default setting for diff text highlighting.  The
" bang (!) is required since we are overwriting the DiffText setting. The highlighting
" for "Todo" also looks nice (yellow) if you don't like the "MatchParen" colors.
hi! link DiffText MatchParen

" Highlight the textwidth column
if exists('&colorcolumn')
  augroup KergothColorColumn
    au!
    au InsertEnter * set colorcolumn=+1
    au InsertLeave * set colorcolumn=
  augroup END
endif

" Highlight the cursor line
set cursorline
" }}}
" Commands {{{
" Grep asynchronously with Dispatch
function! s:Grep(bang, ...)
  let l:errorformat = &errorformat
  let l:makeprg = &makeprg
  let &makeprg = &grepprg
  let &errorformat = &grepformat

  let l:args = copy(a:000)
  call map(l:args, 'shellescape(v:val)')

  try
    execute 'Make' . a:bang . ' ' . join(l:args, ' ')
  finally
    let &errorformat = l:errorformat
    let &makeprg = l:makeprg
  endtry
endfunction
command! -nargs=+ -bang Grep call s:Grep("<bang>", <f-args>)

if !has('nvim')
  " Make the 'Man' command available, loading on demand
  function! s:Man(...)
    runtime ftplugin/man.vim
    execute 'Man' join(a:000, ' ')
  endfunction
  command! -nargs=+ -complete=shellcmd Man delcommand Man | call s:Man(<f-args>)

  set keywordprg=:Man
endif

" Change the current directory to the location of the
" file being edited.
command! -nargs=0 -complete=command Bcd lcd %:p:h

" Add Fix/Format commands for ALEFix
command! -bar -nargs=* -complete=customlist,ale#fix#registry#CompleteFixers Format :call ale#fix#Fix(bufnr(''), '', <f-args>)
" }}}
" Abbreviations {{{
iabbrev adn and
iabbrev teh the
" }}}
" Key Mapping {{{
" Fix command typos
nmap ; :
nnoremap ,; ;

" Make zO recursively open whatever top level fold we're in, no matter where
" the cursor happens to be.
nnoremap zO zCzO

" Show the new foldlevel when changing it
nnoremap <silent> zr zr:<c-u>setlocal foldlevel?<CR>
nnoremap <silent> zm zm:<c-u>setlocal foldlevel?<CR>
nnoremap <silent> zR zR:<c-u>setlocal foldlevel?<CR>
nnoremap <silent> zM zM:<c-u>setlocal foldlevel?<CR>

" Maintain cursor position when joining lines
nnoremap J mzJ`z

" Allow selection past the end of the file for block selection
set virtualedit=block

" Make Y behave sanely (consistent with C, D, ..)
map Y y$

" Make & default to keeping the flags
nnoremap & :&&<CR>
xnoremap & :&&<CR>

" Make jumping to a mark's line+column more convenient with ', not `
nnoremap ' `
nnoremap ` '

" Easy window navigation
noremap <C-h>  <C-w>h
noremap <C-j>  <C-w>j
noremap <C-k>  <C-w>k
noremap <C-l>  <C-w>l
noremap <C-\>  <C-w>p
nnoremap <silent> <C-S-\> :TmuxNavigatePrevious<cr>

" Switch between the last two files
nnoremap ,, <c-^>

" Don't lose visual selection while indenting
vnoremap < <gv
vnoremap > >gv

" Walk history with j/k
cnoremap <c-j> <down>
cnoremap <c-k> <up>

" Tmux will send xterm-style keys when its xterm-keys option is on
if &term =~# '^screen'
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif

" Toggle paste mode with ,P
set pastetoggle=,P

" Clear search, refresh diff, sync syntax, redraw the screen
nnoremap <silent> ,U :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr>:redraw!<cr>

" Select the just-pasted text
nnoremap <expr> ,` '`[' . strpart(getregtype(), 0, 1) . '`]'

" Operate on the just changed/pasted text
onoremap <silent> <expr> ` ':<C-u>norm! `[' . strpart(getregtype(), 0, 1) . '`]<cr>'

" Global search & replace
nnoremap ,s :%s//g<LEFT><LEFT>

" Global search & replace the word under the cursor
nnoremap ,S :%s/\<<C-r><C-w>\>//<Left>

" Grep
nnoremap ,g :Grep<space>

" Grep for the word under the cursor
nnoremap ,G :Grep <C-r><C-w>

" Open a file in the same directory as the current file
nnoremap ,e :e <C-r>=escape(expand('%:p:h'), ' \') . '/<C-d>'<CR>

function! GetBufferList()
  redir =>buflist
  silent! ls!
  redir END
  return buflist
endfunction

function! ToggleList(bufname, pfx)
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
      exec(a:pfx.'close')
      return
    endif
  endfor
  if a:pfx ==# 'l' && len(getloclist(0)) == 0
    echohl ErrorMsg
    echo a:bufname . ' is Empty.'
    return
  elseif a:pfx ==# 'c' && len(getqflist()) == 0
    echohl ErrorMsg
    echo a:bufname . ' is Empty.'
    return
  endif
  let winnr = winnr()
  exec(a:pfx.'open')
  if winnr() != winnr
    wincmd p
  endif
endfunction

" Toggle loclist and quickfix windows
nnoremap <silent> ,wl :call ToggleList("Location List", 'l')<CR>
nnoremap <silent> ,wc :call ToggleList("Quickfix List", 'c')<CR>

" Open a Quickfix window for the last search.
nnoremap <silent> ,w/ :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>

" Show highlight groups under the cursor
nnoremap <silent> ,hl   :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Delete trailing whitespace
function! StripTrailingWhitespace()
  if !&binary && &filetype !=# 'diff'
    normal! mz
    normal! Hmy
    keeppatterns %snomagic/\s\+$//e
    normal! 'yz<CR>
    normal! `z
  endif
endfunction
nnoremap ,W :call StripTrailingWhitespace()<CR>

" Edit the vimrc
nnoremap <silent> ,v :e $MYVIMRC<CR>

" Replace file contents with the selection
vnoremap ,F "qy<CR>:<C-U>exe "normal! ggdG\"qP"<CR>

" Close loclist/quickfix/help
nnoremap <silent> ,wC :lclose \| cclose \| helpclose \| pclose<cr>

" Delete this buffer
nnoremap <silent> ,D :bd<cr>

" Easier getting out of terminal mode
try
  tnoremap <Esc> <C-\><C-n>
  tnoremap <M-[> <Esc>
  tnoremap <C-v><Esc> <Esc>]
catch
endtry

" Convert a single line shell script to multiline
function! SplitShellLine() abort
  silent! exe '%s/ *; */\r/g'
  silent! exe '%s/ *&& */ \\\r \&\&/g'
  silent! exe '%s/ *|| */ \\\r ||/g'
  silent! exe '%s/^\(do\|then\) \(.*\)/\1\r\2/g'
  Format
endfunction

augroup vimrc_mapping
  au!

  au FileType sh,zsh nnoremap <buffer> <silent> L :call SplitShellLine()<cr>

  " dirvish: map `gr` to reload.
  autocmd FileType dirvish nnoremap <silent><buffer>
        \ gr :<C-U>Dirvish %<CR>

  " dirvish: map `gh` to hide dot-prefixed files.  Press `R` to "toggle" (reload).
  autocmd FileType dirvish nnoremap <silent><buffer>
        \ gh :silent keeppatterns g@\v/\.[^\/]+/?$@d _<cr>:setl cole=3<cr>

  " Let ,C also close the dirvish window, from that window
  autocmd FileType dirvish nnoremap <silent><buffer> ,wC <Plug>(dirvish_quit)

  " Let ,C also close the command-line window
  autocmd CmdWinEnter * nnoremap <silent><buffer> ,wC <C-c><C-c>
augroup END

" Unimpaired Mappings {{{
" Functionality from https://github.com/tpope/vim-unimpaired
" Written by Tim Pope <http://tpo.pe/>

" Toggle conceal
function! ToggleConceal() abort
  if &conceallevel == 0
    setlocal conceallevel=1
  else
    setlocal conceallevel=0
  endif
endfunction
nnoremap <silent> =oc :call ToggleConceal()<cr>

" Toggle display of invisible characters
nnoremap =ol :setlocal list!<CR>

" Toggle display of line numbers
nnoremap =on :setlocal number!<CR>

" Toggle relative line numbers
nnoremap =or :setlocal relativenumber!<CR>

" Toggle spell checking
nnoremap =os :setlocal spell!<CR>

" co as well as =o for convenience
if empty(maparg('co', 'n'))
  nmap co =o
endif

" Paired Key Mapping
function! s:MapNextFamily(map, cmd)
  let map = '<Plug>unimpaired'.toupper(a:map)
  let end = ' ".(v:count ? v:count : "")<CR>'
  execute 'nmap <silent> '.map.'Previous :<C-U>exe "'.a:cmd.'previous'.end
  execute 'nmap <silent> '.map.'Next     :<C-U>exe "'.a:cmd.'next'.end
  execute 'nmap <silent> '.map.'First    :<C-U>exe "'.a:cmd.'first'.end
  execute 'nmap <silent> '.map.'Last     :<C-U>exe "'.a:cmd.'last'.end
  execute 'nmap <silent> ['.        a:map .' '.map.'Previous'
  execute 'nmap <silent> ]'.        a:map .' '.map.'Next'
  execute 'nmap <silent> ['.toupper(a:map).' '.map.'First'
  execute 'nmap <silent> ]'.toupper(a:map).' '.map.'Last'
endfunction

" files
call s:MapNextFamily('a', '')
" buffers
call s:MapNextFamily('b', 'b')
" location list
call s:MapNextFamily('l', 'l')
" quickfix
call s:MapNextFamily('q', 'c')
" tags
call s:MapNextFamily('t', 't')
" undo
nnoremap [u g-
nnoremap ]u g+
" }}}
" }}}
" Text Objects {{{
" Fold text-object
vnoremap af :<C-U>silent! normal! [zV]z<CR>
omap     af :normal Vaf<CR>
vnoremap if :<C-U>silent! normal! [zjV]zk<CR>
omap     if :normal Vif<CR>
" }}}
" Terminal and display {{{
" Default to hiding concealed text
if has('conceal')
  set conceallevel=2
endif

" Enable line number column
set number

" Set window title
set title

" I hate 'Thanks for flying VIM'
set titleold=

" Allow setting window title for screen/tmux
if &term =~# '^screen'
  set t_ts=k
  set t_fs=\
  set notitle
endif

" Prefer a wider current window
set winwidth=72
set winminwidth=30

if has('gui_running')
  set guicursor=a:block,a:blinkon0

  " mode aware cursors
  set guicursor+=o:hor50-Cursor
  set guicursor+=n:Cursor
  set guicursor+=i-ci-sm:InsertCursor-ver25
  set guicursor+=r-cr:ReplaceCursor-hor20
  set guicursor+=c:CommandCursor
  set guicursor+=v-ve:VisualCursor

  hi def link InsertCursor Cursor
  hi def link ReplaceCursor Cursor
  hi def link CommandCursor Cursor
  hi def link VisualCursor Cursor
else
  " Adjust cursor in insert mode (bar) and replace mode (underline)
  let &t_SI = "\e[6 q"
  try
    let &t_SR = "\e[4 q"
  catch
  endtry
  let &t_EI = "\e[2 q"

  if !exists('$CURSORCODE')
    let $CURSORCODE = "\e[0 q"
  endif

  augroup vimrc_cursor
    au!
    " Reset cursor on start and exit
    autocmd VimEnter * silent !printf '\e[2 q\n'
    autocmd VimLeave * silent !printf "$CURSORCODE"
  augroup END
endif

" Always show the status line
set laststatus=2

" No need for a mode indicator when I can rely on the cursor
set noshowmode

" Set up statusline
set statusline=
set statusline+=%2*%(\ %{&paste?'PASTE':''}\ %)%*
set statusline+=%3*
set statusline+=%(\ %{vimrc#statusline#Filename_Modified()}\ %)
set statusline+=%*
set statusline+=%(%{vimrc#statusline#Readonly()}\ %)

set statusline+=%=

set statusline+=%(%{&ft}\ %)
set statusline+=%*%1*
set statusline+=%6(\ %p%%\ %)
set statusline+=%#warningmsg#
set statusline+=%(\ %{&fileformat!=#'unix'?&fileformat:''}\ %)
set statusline+=%(\ %{&fileencoding!=#'utf-8'?&fileencoding:''}\ %)

let g:statusline_quickfix = "%t%{exists('w:quickfix_title')?' '.w:quickfix_title:''}"

augroup vimrc_statusline
  au!
  " Remove the position info from the quickfix statusline
  au BufWinEnter quickfix if exists('g:statusline_quickfix') | let &l:statusline = g:statusline_quickfix | endif
augroup END

" Align titlestring with statusline
if has('gui_running') || &title
  set titlestring=%(%{&bt!=#''?&bt:vimrc#statusline#Filename_Modified()}\ %)
  set titlestring+=%{vimrc#statusline#Readonly()}
endif

" Setup color scheme
function! s:OverrideColors() abort
  hi! link Error NONE
  hi! Error ctermbg=darkred guibg=darkred ctermfg=black guifg=black
endfunction

augroup vimrc_colorscheme
  autocmd!
  autocmd ColorScheme * :call s:OverrideColors()
augroup END

" Default colorscheme for fallback
if !exists('g:colors_name')
  if &t_Co >= 88
    colorscheme baycomb
  else
    colorscheme desert
  endif
endif

" Assume we have a decent terminal, as vim only recognizes a very small set of
" $TERM values for the default enable.
set ttyfast

" Avoid unnecessary redraws
set lazyredraw

if !has('nvim') && has('mouse_xterm')
  " Assume we're using a terminal that can handle this, as vim's automatic
  " enable only recognizes a limited set of $TERM values
  if !&ttymouse
    set ttymouse=xterm2
  endif
endif

" Folding text function from Gregory Pakosz, with l:end removed
function! FoldText()
  let l:lpadding = &foldcolumn
  redir => l:signs
  execute 'silent sign place group=* buffer='.bufnr('%')
  redir End
  let l:lpadding += l:signs =~# 'id=' ? 2 : 0

  if exists('+relativenumber')
    if (&number)
      let l:lpadding += max([&numberwidth, strlen(line('$'))]) + 1
    elseif (&relativenumber)
      let l:lpadding += max([&numberwidth, strlen(v:foldstart - line('w0')), strlen(line('w$') - v:foldstart), strlen(v:foldstart)]) + 1
    endif
  else
    if (&number)
      let l:lpadding += max([&numberwidth, strlen(line('$'))]) + 1
    endif
  endif

  " expand tabs
  let l:start = substitute(getline(v:foldstart), '\t', repeat(' ', &tabstop), 'g')

  let l:info = ' (' . (v:foldend - v:foldstart) . ')'
  let l:infolen = strlen(substitute(l:info, '.', 'x', 'g'))
  let l:width = winwidth(0) - l:lpadding - l:infolen

  let l:separator = ' … '
  let l:separatorlen = strlen(substitute(l:separator, '.', 'x', 'g'))
  let l:start = strpart(l:start , 0, l:width - l:separatorlen)
  let l:text = l:start . ' … '

  return l:text . repeat(' ', l:width - strlen(substitute(l:text, '.', 'x', 'g'))) . l:info
endfunction
set foldtext=FoldText()
" }}}
" GUI settings {{{
if has('gui_running')
  if has('gui_macvim')
    set guifont=InputMonoNarrow\ Thin:h14
    set macligatures
    set macthinstrokes
    set macmeta
  else
    set guifont=InputMonoNarrow\ Thin\ 14
  endif

  " Turn off toolbar and menu
  set guioptions-=T
  set guioptions-=m

  " Disable gui tab line in favor of the text one
  set guioptions-=e

  " use console dialogs instead of popup
  " dialogs for simple choices
  set guioptions+=c

  augroup gvimrc
    au!
    au GUIEnter * set columns=96 lines=48
  augroup END
end
" }}}
" File type detection {{{
augroup vimrc_filetype_detect
  au!

  au BufNewFile,BufRead TODO,BUGS,README set ft=text
  au BufNewFile,BufRead ~/.config/git/config set ft=gitconfig

  au BufNewFile,BufRead git-revise-todo setf gitrebase

  " My dotfiles install scripts are shell
  au BufNewFile,BufRead install setf sh

  " Mentor Embedded Linux & OpenEmbedded/Yocto
  au BufNewFile,BufRead local.conf.append* set ft=bitbake
  au BufNewFile,BufRead setup-environment,oe-init-build-env set ft=sh

  " Default ft is 'text'
  au BufNewFile,BufReadPost * if &ft ==# '' | set ft=text | endif

  " Treat buffers from stdin (e.g.: echo foo | vim -) as scratch.
  au StdinReadPost * :set buftype=nofile
augroup END
" }}}
" File type settings {{{
augroup vimrc_filetypes
  au!

  " Set filetypes

  " File type specific indentation settings
  au FileType vim set sts=2 sw=2 et
  au FileType gitconfig set sts=0 sw=8 noet

  " Comment string
  au FileType gitconfig set cms=#%s

  " Set up folding
  au FileType c,cpp,lua,vim,sh,go,gitcommit set fdm=syntax
  au FileType text set fdm=indent
  au FileType man set fdl=99 fdm=manual

  " Default to indent based folding rather than manual
  au FileType *
        \ if  &filetype == '' |
        \   set fdm=indent |
        \ endif

  " Default to syntax completion if we have nothing better
  au FileType *
        \ if &omnifunc == "" |
        \   set omnifunc=syntaxcomplete#Complete |
        \ else |
        \   let b:vcm_tab_complete = 'omni' |
        \ endif

  " Diff context begins with a space, so blank lines of context
  " are being inadvertantly flagged as redundant whitespace.
  " Adjust the match to exclude the first column.
  au Syntax diff match RedundantWhitespace /\%>1c\(\s\+$\| \+\ze\t\)/

  " Add headings with <localleader> + numbers
  au Filetype rst nnoremap <buffer> <localleader>1 yypVr=
  au Filetype rst nnoremap <buffer> <localleader>2 yypVr-
  au Filetype rst nnoremap <buffer> <localleader>3 yypVr~
  au Filetype rst nnoremap <buffer> <localleader>4 yypVr`
  au Filetype markdown nnoremap <buffer> <localleader>1 I#<space>
  au Filetype markdown nnoremap <buffer> <localleader>2 I##<space>
  au Filetype markdown nnoremap <buffer> <localleader>3 I###<space>
  au Filetype markdown nnoremap <buffer> <localleader>4 I####<space>

  " Don't restore position in a git commit message
  au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
augroup END

" Highlight GNU gcc specific items
let g:c_gnu = 1

" Allow posix elements like $() in /bin/sh scripts
let g:is_posix = 1

" Enable syntax folding
let g:javaScript_fold = 1
let g:markdown_folding = 1
let g:perl_fold = 1
let g:perl_fold_blocks = 1
let g:php_folding = 1
let g:r_syntax_folding = 1
let g:ruby_fold = 1
let g:rust_fold = 1
let g:sh_fold_enabled = 7
let g:tex_fold_enabled = 1
let g:vimsyn_folding = 'af'
let g:xml_syntax_folding = 1

" Disable new bitbake file template
let g:bb_create_on_empty = 0
" }}}
" Plugins {{{
if !has('nvim')
  if v:version >= 800
    packadd! matchit
  else
    runtime macros/matchit.vim
  endif
endif

if has('nvim') || v:version >= 800
  packadd! cfilter
endif

" Settings that need to be set before loading the plugin
let g:dispatch_no_maps = 1
let g:endwise_no_mappings = 1
let g:fzf_command_prefix = 'FZF'
let g:vcm_default_maps = 0

" Disable the minisnip default mappings
imap <Plug>(no_minisnip_complete) <Plug>(minisnip-complete)

" Mappings if the FZF plugin isn't available yet
if maparg('<C-b>', 'n') ==# ''
  nnoremap <C-b> :b <C-d>
endif
if maparg('<C-p>', 'n') ==# ''
  nnoremap <C-p> :e **/
endif

" Disable built-in plugins
let g:loaded_2html_plugin = 1
let g:loaded_getscript = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_gzip = 1
let g:loaded_logiPat = 1
let g:loaded_netrw = 1
let g:loaded_netrwFileHandlers = 1
let g:loaded_netrwPlugin = 1
let g:loaded_netrwSettings = 1
let g:loaded_rrhelper = 1
let g:loaded_spellfile_plugin = 1
let g:loaded_tar = 1
let g:loaded_tarPlugin = 1
let g:loaded_tohtml = 1
let g:loaded_tutor = 1
let g:loaded_vimball = 1
let g:loaded_vimballPlugin = 1
let g:loaded_zip = 1
let g:loaded_zipPlugin = 1
" }}}
" Finale {{{
" Load split-out vimrc components
runtime! config/*.vim

" Load a site specific vimrc if one exists (useful for things like font sizes)
if !exists('$HOSTNAME')
  let $HOSTNAME = hostname()
endif
runtime vimrc.$HOSTNAME
runtime vimrc.local
" }}}
