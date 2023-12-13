if (-Not (Test-Path $env:USERPROFILE\.local\share\vim\backup)) {
    New-Item -ItemType Directory -Force $env:USERPROFILE\.local\share\vim\backup | Out-Null
}
if (-Not (Test-Path $env:USERPROFILE\.local\share\vim\undo)) {
    New-Item -ItemType Directory -Force $env:USERPROFILE\.local\share\vim\undo | Out-Null
}
if (-Not (Test-Path $env:USERPROFILE\.local\share\nvim\shada)) {
    New-Item -ItemType Directory -Force $env:USERPROFILE\.local\share\nvim\shada | Out-Null
}

if (-Not (Test-Path $env:USERPROFILE\.config\vim\pack\bundle\opt\minpac)) {
    git clone --depth 1 https://github.com/k-takata/minpac $env:USERPROFILE\.config\vim\pack\bundle\opt\minpac
}

if (Get-Command nvim -ErrorAction SilentlyContinue) {
    $null | nvim --headless -u $env:USERPROFILE\.config\vim\vimrc -c PackUpdateAndQuit
}
elseif (Get-Command vim -ErrorAction SilentlyContinue) {
    $null | vim -E -u $env:USERPROFILE\.config\vim\vimrc -c PackUpdateAndQuit
}
