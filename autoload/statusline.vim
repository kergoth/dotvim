function! statusline#get_highlight_line(group)
  " Redirect the output of the "hi" command into a variable
  " and find the highlighting
  redir => GroupDetails
  exe 'silent hi ' . a:group
  redir END

  " Resolve linked groups to find the root highlighting scheme
  while GroupDetails =~# 'links to'
    let index = stridx(GroupDetails, 'links to') + len('links to')
    let LinkedGroup =  strpart(GroupDetails, index + 1)
    redir => GroupDetails
    exe 'silent hi ' . LinkedGroup
    redir END
  endwhile

  " Extract the highlighting details (the bit after "xxx")
  let MatchGroups = matchlist(GroupDetails, '\<xxx\>\s\+\(.*\)')
  let ExistingHighlight = MatchGroups[1]
  return ExistingHighlight
endfunction

function! statusline#highlight_args(group) abort
  let output = statusline#get_highlight_line(a:group)
  let hidict = {}
  for item in split(output, '\s\+')
    if match(item, '=') > 0
      let splited = split(item, '=')
      let hidict[splited[0]] = splited[1]
    endif
  endfor
  return hidict
endfunction

function! statusline#highlight_args_string(hidict) abort
  let entries = []
  for item in items(a:hidict)
    let entries += [join(item, '=')]
  endfor
  return join(entries)
endfunction

function! statusline#copy_dict_items(from, to, terms) abort
  for term in a:terms
    if has_key(a:from, term)
      let a:to[term] = a:from[term]
    endif
  endfor
  return a:to
endfunction

" Example:
" let s:statusline_dracula_colors = {
"       \ 'User1': {'Comment': {'override': 'gui=reverse cterm=reverse guibg=white ctermbg=white'}},
"       \ 'User2': {'Number': {'override': 'gui=reverse cterm=reverse guibg=black ctermbg=black'}},
"       \ 'User3': {'StatusLine': {'copy': 'ctermfg guifg'}, 'Identifier': {'copy': 'ctermfg guifg'}},
"       \ }
function! statusline#set_colors(colors) abort
  for [group, rules] in items(a:colors)
    let result = []
    for [fromgroup, fromrules] in items(rules)
      let override = get(fromrules, 'override', '')
      if override !=# ''
        let failed = add(result, statusline#get_highlight_line(fromgroup))
        let failed = add(result, override)
      endif

      let copyitems = get(fromrules, 'copy', '')
      if copyitems !=# ''
        let higroup = statusline#highlight_args(fromgroup)
        if copyitems ==# 'all'
          let hidict = higroup
        else
          let hidict = statusline#copy_dict_items(higroup, {}, split(copyitems))
        endif
        let failed = add(result, statusline#highlight_args_string(hidict))
      endif
    endfor
    exe 'hi ' . group . ' ' . join(result, ' ')
  endfor
endfunction

if exists('*pathshorten')
  function! statusline#pathshorten(path)
    return pathshorten(fnamemodify(a:path, ':~:.'))
  endfunction
else
  function! statusline#pathshorten(path)
    return fnamemodify(a:path, ':t')
  endfunction
endif

function! statusline#Filename_Modified()
  " Avoid the component separator between filename and modified indicator
  let filename = expand('%')
  let basename = fnamemodify(filename, ':t')

  if filename ==# ''
    return '[No Name]'
  elseif &filetype ==# 'help'
    return basename
  endif

  if basename ==# ''
    " Shorten without the trailing / for directories
    let pathsep = has('win32') ? '\' : '/'
    let filename = statusline#pathshorten(fnamemodify(filename, ':h')) . pathsep
  else
    let filename = statusline#pathshorten(filename)
  endif
  let modified = &modified ? '+' : ''
  return filename . modified
endfunction

function! statusline#Readonly()
  return &readonly && &filetype !=# 'help' ? 'RO' : ''
endfunction
