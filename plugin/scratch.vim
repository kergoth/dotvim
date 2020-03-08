" See https://vimways.org/2019/writing-vim-plugin/
" and https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7

if exists('g:loaded_scratch')
    finish
endif
let g:loaded_scratch = 1

function! s:scratch(mods, cmd) abort
    if a:cmd is# ''
        let l:output = ''
    elseif a:cmd[0] is# '@'
        if strlen(a:cmd) is# 2
            let l:output = getreg(a:cmd[1], 1, v:true)
        else
            throw 'Invalid register'
        endif
    elseif a:cmd[0] is# '!'
        let l:cmd = a:cmd =~' %' ? substitute(a:cmd, ' %', ' ' . expand('%:p'), '') : a:cmd
        let l:output = systemlist(matchstr(l:cmd, '^!\zs.*'))
    else
        let l:output = split(execute(a:cmd), "\n")
    endif

    execute a:mods . ' new'
    Scratchify
    call setline(1, l:output)
endfunction

command! Scratchify setlocal nobuflisted noswapfile buftype=nofile bufhidden=delete
command! -nargs=? -complete=command Scratch call <SID>scratch(<q-mods>, <q-args>)
command! -nargs=? -complete=command Redir call <SID>scratch(<q-mods>, <q-args>)
