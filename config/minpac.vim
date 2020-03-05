command! PackUpdate call vimrc#minpac#packages() | call minpac#update('', {'do': 'call minpac#status()'})
command! PackUpdateAndQuit call vimrc#minpac#packages() | call minpac#update('', {'do': 'quit'})
command! PackClean  call vimrc#minpac#packages() | call minpac#clean()
command! PackStatus call vimrc#minpac#packages() | call minpac#status()
