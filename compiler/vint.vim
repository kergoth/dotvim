if exists('current_compiler')
  finish
endif
let current_compiler = 'vint'

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=vint\ %
CompilerSet errorformat&
