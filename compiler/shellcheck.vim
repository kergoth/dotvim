setlocal makeprg=shellcheck\ -f\ gcc\ --\ %:S
setlocal errorformat=%f:%l:%c:\ %m\ [SC%n]
