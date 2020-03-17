" Bootstrap {{{
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

if v:version >= 800 && !has('nvim')
  unlet! skip_defaults_vim
  source $VIMRUNTIME/defaults.vim
else
  " Use version embedded in my dotvim
  runtime embedded/defaults.vim
endif

" Use XDG paths
if !has('nvim')
  if empty($XDG_DATA_HOME)
    let $XDG_DATA_HOME = $HOME . '/.local/share'
  endif

  set directory=$XDG_DATA_HOME/vim/swap//
  set backupdir=$XDG_DATA_HOME/vim/backup
  if has('persistent_undo')
    set undodir=$XDG_DATA_HOME/vim/undo
  endif
  set viewdir=$XDG_DATA_HOME/vim/view
  let g:netrw_home = $XDG_DATA_HOME . '/vim'

  if has('viminfo')
    if exists('&viminfofile')
      set viminfofile=$XDG_DATA_HOME/vim/viminfo
    else
      let s:viminfofile = $XDG_DATA_HOME . '/vim/viminfo'
    endif
  endif
else
  let g:netrw_home = $XDG_DATA_HOME . '/nvim'
  set backupdir-=.
endif

" Ensure we cover all temp files for backup file creation
if $OSTYPE =~? 'darwin'
  set backupskip+=/private/tmp/*
endif

" vint: -ProhibitAutocmdWithNoGroup
exe 'augroup my'
autocmd!

" Double slash does not actually work for backupdir, here's a fix
autocmd BufWritePre * let &backupext='@'.substitute(substitute(substitute(expand('%:p:h'), '/', '%', 'g'), '\', '%', 'g'), ':', '', 'g')
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

" Don't include options in session and views
set sessionoptions-=options
set viewoptions-=options

" Viminfo file behavior
if has('viminfo') || has('shada')
  " !   save capital global variables
  " f1  store file marks
  " '   # of previously edited files to remember marks for
  " :   # of lines of command history
  " /   # of lines of search pattern history
  " <   max # of lines for each register to be saved
  " s   max # of Kb for each register to be saved
  " h   don't restore hlsearch behavior
  set viminfo=!,f1,'1000,:1000,/1000,<1000,s100,h,r/tmp
  if !exists('&viminfofile')
    let &viminfo .= ',n' . s:viminfofile
  endif
endif

" Allow hiding buffers with modifications
set hidden

" Prompt me rather than aborting an action
set confirm

" Automatically reload files changed outside of vim
set autoread

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
set cmdheight=2

" Longer command/search history
set history=1000

if has('folding')
  " Default with all folds open
  set foldlevelstart=99
endif

" Disable scanning included files
set complete-=i

" Disable searching tags
set complete-=t

" Always show the completion menu for the preview
set completeopt=longest,menuone,preview

" Make completion list behave more like a shell
set wildmode=longest:full,full

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
  let &listchars = "tab:\u21e5 ,eol:\u00ac,trail:\u2423,extends:\u21c9,precedes:\u21c7,nbsp:\u26ad"
endif
set fillchars=stl:\ ,stlnc:\ ,vert:\ ,fold:\ ,diff:-

" Do soft word wrapping at chars in breakat
if has('linebreak')
  set linebreak
  try
    set breakindent
  catch
  endtry
  set cpoptions+=n
end

if &shell =~# 'fish$' && (v:version < 704 || v:version == 704 && !has('patch276'))
  set shell=/usr/bin/env\ bash
endif

if has('win32')
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


" Reload vimrc on save
autocmd BufWritePost $MYVIMRC nested source $MYVIMRC

" Default to closed marker folds in my vimrc
autocmd BufRead $MYVIMRC setl fdm=marker | if &foldlevel == &foldlevelstart | setl foldlevel=0 | endif

" Resize splits when the window is resized
autocmd VimResized * exe "normal! \<c-w>="

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
autocmd FileType qf call AdjustWindowHeight(3, 10)

" Close out the quickfix window if it's the only open window
function! s:QuickFixClose()
  if &buftype ==# 'quickfix'
    " if this window is last on screen, quit
    if winnr('$') < 2
      quit
    endif
  endif
endfunction
autocmd BufEnter * call <SID>QuickFixClose()

" Close preview window when the completion menu closes
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" Unset paste on InsertLeave
autocmd InsertLeave * silent! set nopaste

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

  autocmd BufEnter * if s:TmuxRename() && empty(&buftype) | call system('tmux rename-window '.expand('%:t:S')) | endif
  autocmd VimLeave * if s:TmuxRename() | call system('tmux set-window automatic-rename on') | endif
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
" }}}
" Indentation and formatting {{{
set formatoptions+=rn1j
set formatoptions-=t

" 4 space indentation by default
set shiftwidth=4
set softtabstop=4
set expandtab

" Obey shiftwidth when inserting tabs at the start of line
set smarttab

" Copy indent from current line when starting a new line
set autoindent

" Copy structure of existing line's indent when adding a new line
set copyindent

" Wrap at column 78
set textwidth=78
" }}}
" Syntax and highlighting {{{
" Colors red both trailing whitespace:
"  foo   
"  bar	
" And spaces before tabs:
"  foo 	bar
highlight link RedundantWhitespace Error
autocmd Syntax * syntax match RedundantWhitespace excludenl /\s\+\%#\@<!$\| \+\ze\t/ display containedin=ALL

" Highlight too-long git commit message summaries
highlight link gitcommitOverflow Error

" Highlight our vim modeline
highlight link VimModeline Special
autocmd Syntax * syntax match VimModeline excludenl /vim:\s*set[^:]\{-1,\}:/ display containedin=ALL

" Fix the difficult-to-read default setting for diff text highlighting.  The
" bang (!) is required since we are overwriting the DiffText setting. The highlighting
" for "Todo" also looks nice (yellow) if you don't like the "MatchParen" colors.
hi! link DiffText MatchParen

" Highlight the textwidth column
if exists('&colorcolumn')
  autocmd InsertEnter * set colorcolumn=+1
  autocmd InsertLeave * set colorcolumn=
endif

" Highlight the cursor line
autocmd InsertLeave,WinEnter * set cursorline
autocmd InsertEnter,WinLeave * set nocursorline
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
" }}}
" Abbreviations {{{
iabbrev adn and
iabbrev teh the
" }}}
" Key Mapping {{{
" Fix command typos
nmap ; :
nnoremap ,; ;

" Navigate over visual lines
noremap j gj
noremap k gk
noremap gj j
noremap gk k

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

" Background here: https://gist.github.com/romainl/047aca21e338df7ccf771f96858edb86
function! CCR()
  let cmdline = getcmdline()
  command! -bar Z silent set more|delcommand Z
  if getcmdtype() != ':'
    return "\<CR>"
  endif
  if cmdline =~# '\v\C^(ls|files|buffers)'
    " like :ls but prompts for a buffer command
    return "\<CR>:b"
  elseif cmdline =~# '\v\C/(#|nu|num|numb|numbe|number)$'
    " like :g//# but prompts for a command
    return "\<CR>:"
  elseif cmdline =~# '\v\C^(dli|il)'
    " like :dlist or :ilist but prompts for a count for :djump or :ijump
    return "\<CR>:" . cmdline[0] . 'j  ' . split(cmdline, ' ')[1] . "\<S-Left>\<Left>"
  elseif cmdline =~# '\v\C^(cli|lli)'
    " like :clist or :llist but prompts for an error/location number
    return "\<CR>:sil " . repeat(cmdline[0], 2) . "\<Space>"
  elseif cmdline =~# '\C^old'
    " like :oldfiles but prompts for an old file to edit
    set nomore
    return "\<CR>:Z|e #<"
  elseif cmdline =~# '\C^changes'
    " like :changes but prompts for a change to jump to
    set nomore
    return "\<CR>:Z|norm! g;\<S-Left>"
  elseif cmdline =~# '\C^ju'
    " like :jumps but prompts for a position to jump to
    set nomore
    return "\<CR>:Z|norm! \<C-o>\<S-Left>"
  elseif cmdline =~# '\C^marks'
    " like :marks but prompts for a mark to jump to
    return "\<CR>:norm! `"
  elseif cmdline =~# '\C^undol'
    " like :undolist but prompts for a change to undo
    return "\<CR>:u "
  elseif cmdline =~# '\C^reg'
    return "\<CR>:norm! \"p\<Left>"
  elseif cmdline =~# '\C^tags'
    return "\<CR>:pop\<Home>"
  else
    return "\<CR>"
  endif
endfunction
cnoremap <expr> <CR> CCR()

" Easier getting out of terminal mode
try
  tnoremap <Esc> <C-\><C-n>
  tnoremap <M-[> <Esc>
  tnoremap <C-v><Esc> <Esc>]
catch
endtry

" Break undo so each word deleted is its own.
" Revert with ":iunmap <C-W>".
inoremap <C-W> <C-G>u<C-W>

" Disable ^C in insert mode, as it exits without the InsertLeave event
inoremap <C-c> <NOP>

" Convert a single line shell script to multiline
function! SplitShellLine() abort
  silent! exe '%s/ *; */\r/g'
  silent! exe '%s/ *&& */ \\\r \&\&/g'
  silent! exe '%s/ *|| */ \\\r ||/g'
  silent! exe '%s/^\(do\|then\) \(.*\)/\1\r\2/g'
  Format
endfunction

autocmd FileType sh,zsh nnoremap <buffer> <silent> L :call SplitShellLine()<cr>

" Let ,wC also close the command-line window
autocmd CmdWinEnter * nnoremap <silent><buffer> ,wC <C-c><C-c>

" Unimpaired-based Mappings {{{
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
nnoremap <silent> =oC :call ToggleConceal()<cr>

" Toggle display of invisible characters
nnoremap <silent> =ol :setlocal list!<CR>

" Toggle display of line numbers
nnoremap <silent> =on :setlocal number!<CR>

" Toggle relative line numbers
nnoremap <silent> =or :setlocal relativenumber!<CR>

" Toggle spell checking
nnoremap <silent> =os :setlocal spell!<CR>

" co as well as =o for convenience
if empty(maparg('co', 'n'))
  nmap co =o
endif

" Paired Key Mapping
" Files
nmap <silent> [a :<C-U>exe ":".v:count."previous"<CR>
nmap <silent> ]a :<C-U>exe ":".v:count."next"<CR>
" Buffers
nmap <silent> [b :<C-U>exe ":".v:count."bprevious"<CR>
nmap <silent> ]b :<C-U>exe ":".v:count."bnext"<CR>
" Location list
nmap <silent> [l :<C-U>exe ":".v:count."lprevious"<CR>
nmap <silent> ]l :<C-U>exe ":".v:count."lnext"<CR>
" Quickfix
nmap <silent> [q :<C-U>exe ":".v:count."cprevious"<CR>
nmap <silent> ]q :<C-U>exe ":".v:count."cnext"<CR>
" Tags
nmap <silent> [t :<C-U>exe ":".v:count."tprevious"<CR>
nmap <silent> ]t :<C-U>exe ":".v:count."tnext"<CR>
" Undo
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

  " Reset cursor on start and exit
  autocmd VimEnter * silent !printf '\e[2 q\n'
  autocmd VimLeave * silent !printf "$CURSORCODE"
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

" Remove the position info from the quickfix statusline
autocmd BufWinEnter quickfix if exists('g:statusline_quickfix') | let &l:statusline = g:statusline_quickfix | endif

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

autocmd ColorScheme * :call s:OverrideColors()

" Default colorscheme for fallback
if &t_Co > 2 || has('gui_running')
  " Allow color schemes to do bright colors without forcing bold.
  if &t_Co == 8 && $TERM !~# '^Eterm'
    set t_Co=16
  endif
  if !exists('g:colors_name')
    if &t_Co >= 88
      colorscheme baycomb
    else
      colorscheme desert
    endif
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

autocmd BufReadPost quickfix call vimrc#quickfix#format()
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

  autocmd GUIEnter * set columns=96 lines=48
end
" }}}
" File type detection {{{
autocmd BufNewFile,BufRead git-revise-todo setf gitrebase

" My dotfiles install scripts are shell
autocmd BufNewFile,BufRead install setf sh

" Mentor Embedded Linux & OpenEmbedded/Yocto
autocmd BufNewFile,BufRead local.conf.append* set ft=bitbake
autocmd BufNewFile,BufRead setup-environment,oe-init-build-env set ft=sh

" Default ft is 'text'
autocmd BufNewFile,BufReadPost * if &ft ==# '' | set ft=text | endif

" Treat buffers from stdin (e.g.: echo foo | vim -) as scratch.
autocmd StdinReadPost * :set buftype=nofile
" }}}
" File type settings {{{
" Indentation settings
autocmd FileType vim setlocal sts=2 sw=2 et
autocmd FileType gitconfig setlocal sts=0 sw=8 noet

" Comment string
autocmd FileType gitconfig setlocal cms=#%s

" Folding
autocmd FileType c,cpp,lua,vim,sh setlocal fdm=syntax
autocmd FileType text setlocal fdm=indent

" Default to syntax completion if we have nothing better
autocmd FileType *
      \ if &omnifunc == "" |
      \   setlocal omnifunc=syntaxcomplete#Complete |
      \ else |
      \   let b:vcm_tab_complete = 'omni' |
      \ endif

" Ignore whitespace issues in patch files
autocmd Syntax diff highlight link RedundantWhitespace NONE

" Add headings
autocmd FileType rst nnoremap <buffer> \1 yypVr=
autocmd FileType rst nnoremap <buffer> \2 yypVr-
autocmd FileType rst nnoremap <buffer> \3 yypVr~
autocmd FileType rst nnoremap <buffer> \4 yypVr`
autocmd FileType markdown nnoremap <buffer> \1 I#<space>
autocmd FileType markdown nnoremap <buffer> \2 I##<space>
autocmd FileType markdown nnoremap <buffer> \3 I###<space>
autocmd FileType markdown nnoremap <buffer> \4 I####<space>

" Don't restore position in a git commit message
autocmd FileType gitcommit augroup my_gitcommit | autocmd! | autocmd BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0]) | augroup END

" Highlight GNU gcc specific items
let g:c_gnu = 1

" Allow posix elements like $() in /bin/sh scripts
let g:is_posix = 1

" Enable ft/syntax folding
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
let g:ft_man_folding_enable = 1

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
exe 'augroup END'
" }}}
" vim: set sw=2 sts=2 et:
