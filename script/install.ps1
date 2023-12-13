$repopath = Split-Path -Parent $PSScriptRoot

if (Test-Path (Join-Path $env:USERPROFILE _vimrc)) {
    Remove-Item -Force (Join-Path $env:USERPROFILE _vimrc)
}
if (-Not (Test-Path (Join-Path $env:USERPROFILE .config))) {
    New-Item -Force -Path (Join-Path $env:USERPROFILE .config) -ItemType Directory
}
Copy-Item -Force (Join-Path $repopath vimrc.redir) (Join-Path $env:USERPROFILE _vimrc)
Copy-Item -Force (Join-Path $repopath vimrc.redir) (Join-Path $env:USERPROFILE .config\nvim\init.vim)
if (-Not (Test-Path (Join-Path $env:USERPROFILE .config\vim))) {
    New-Item -Force -Path (Join-Path $env:USERPROFILE .config/vim) -ItemType SymbolicLink -Value $repopath
}

Join-Path $PSScriptRoot /update.ps1 | Invoke-Expression
