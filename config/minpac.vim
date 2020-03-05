command! PackUpdate call vimrc#minpac#packages() | call minpac#update('', {'do': 'call minpac#status()'})
command! PackClean  call vimrc#minpac#packages() | call minpac#clean()
command! PackStatus call vimrc#minpac#packages() | call minpac#status()
