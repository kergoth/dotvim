if (-Not (Test-Path $env:USERPROFILE\.local\state\vim\backup)) {
    New-Item -ItemType Directory -Force $env:USERPROFILE\.local\state\vim\backup | Out-Null
}
if (-Not (Test-Path $env:USERPROFILE\.local\state\vim\undo)) {
    New-Item -ItemType Directory -Force $env:USERPROFILE\.local\state\vim\undo | Out-Null
}
if (-Not (Test-Path $env:USERPROFILE\.local\state\nvim\shada)) {
    New-Item -ItemType Directory -Force $env:USERPROFILE\.local\state\nvim\shada | Out-Null
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
