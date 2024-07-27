# =============== oh my posh theme =============== 
oh-my-posh init pwsh --config 'C:\Users\FadlM\customization\oh-my-posh\themes\custom_kali.omp.json' | Invoke-Expression

# =============== Additional Functions ===============

function Test-CommandExists {
  param($command)
  $exists = $null -ne (Get-Command $command -ErrorAction SilentlyContinue)
  return $exists
}

# Editor Configuration
$EDITOR = if (Test-CommandExists nvim) { 'nvim' }
elseif (Test-CommandExists pvim) { 'pvim' }
elseif (Test-CommandExists vim) { 'vim' }
elseif (Test-CommandExists vi) { 'vi' }
elseif (Test-CommandExists code) { 'code' }
elseif (Test-CommandExists notepad++) { 'notepad++' }
elseif (Test-CommandExists sublime_text) { 'sublime_text' }
else { 'notepad' }
Set-Alias -Name vim -Value $EDITOR

# =============== Aliases ===============

# Simple Aliases
Set-Alias l "Get-ChildItem"
Set-Alias c "Clear-Host"
Set-Alias h "Get-History"
Set-Alias j "Get-Job"
Set-Alias g "git"
Set-Alias python3 "python"
Set-Alias pip3 "pip"

# =============== Functions ===============

# --- npm functions ---
function ninit { npm init $args }
function nin { npm install $args }
function nr { npm run $args }
function ns { npm start $args }
function nt { npm test $args }
function nb { npm run build $args }
function nrd { npm run dev $args }

# --- docker-compose functions ---
function dcu { docker-compose up $args }
function dcd { docker-compose down $args }
function dcb { docker-compose build $args }
function dce { docker-compose exec $args }
function dcl { docker-compose logs $args }
function dcp { docker-compose ps $args }
function dcr { docker-compose restart $args }
function dcs { docker-compose stop $args }

# --- bash-like functions ---
function ll { Get-ChildItem -Force -File | Format-List }
function la { Get-ChildItem -Force }

function mkcd {
  param ($dir)
  New-Item -Path $dir -ItemType Directory -Force
  Set-Location -Path $dir
}

function .. { Set-Location .. }
function ... { Set-Location ../.. }
function .... { Set-Location ../../.. }

# Searching (PowerShell equivalents for grep)
function grep { Select-String $args }
# Function to simulate `cat` and `grep` combination in PowerShell
function Search-File {
    param (
        [string]$filePath,
        [string]$pattern
    )
    
    try {
        if (-Not (Test-Path $filePath)) {
            throw "File not found: $filePath"
        }
        
        $content = Get-Content $filePath -ErrorAction Stop
        $patternMatches = $content | Select-String $pattern -ErrorAction Stop
        
        if ($patternMatches) {
            return $patternMatches
        } else {
            Write-Output "No matches found for pattern: $pattern"
        }
    }
    catch {
        Write-Error "An error occurred: $_"
    }
}

# System update and upgrade (Windows equivalent)
function update { winget upgrade --all }
function updatey { winget upgrade --all --accept-source-agreements }

# Networking
function ipinfo { Invoke-RestMethod http://ipinfo.io; Write-Output "" }
function getip { (Invoke-WebRequest http://ifconfig.me).Content; Write-Output "" }

# --- Git functions ---
function gi { git init $args }
function clone { git clone $args }
function ga { git add $args }
function gst { git status $args }
function gco { git checkout $args }
function gbr { git branch $args }
function gcmsg ($message) {
  if (-not $message) {
    Write-Error "Error: Please provide a commit message."
    return
  }
  git commit -m $message $args
}
function gdf { git diff $args }
function glg { git log --oneline --graph --decorate --all $args }
function gls { git log --stat $args }
function glast { git log -1 HEAD $args }
function gunstage { git reset HEAD -- $args }
function guncommit { git reset --soft HEAD^ $args }
function gamend { git commit --amend $args }
function galiases { git config --get-regexp '^alias\.' $args }
function gpl { git pull $args }
function gpsh { git push $args }  # Changed from gps to gitps

# ///// CyberDefenders Project Functions \\\\\
function activateVenv { & .\venv\Scripts\activate }
function managePy { python manage.py $args }
function runServer { python manage.py runserver $args }
function installPyDeps { pip install -r requirements.txt $args }

function cydefBoot {
  activateVenv
  runServer
}

# =============== Modules =================
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -PredictionSource HistoryAndPlugin

Import-Module Terminal-Icons
Import-Module -Name Microsoft.WinGet.CommandNotFound

# =============== Chocolatey Profile ===============
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path $ChocolateyProfile) {
  Import-Module "$ChocolateyProfile"
}

function whereis ($command) {
  if (-not $command) {
    Write-Error "Error: Please provide a command to search for."
    return
  }
  Get-Command -Name $command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source
}

function which($name) {
  if (-not $name) {
    Write-Error "Error: Please provide a command to search for."
    return
  }
  Get-Command -Name $name | Select-Object -ExpandProperty Definition
}

function touch ($filename) {
  if (-not $filename) {
    Write-Error "Error: Please provide a filename."
    return
  }
  New-Item -Path $filename -ItemType File
}

function rmrf ($folder) {
  if (-not $folder) {
    Write-Error "Error: Please provide a folder to delete."
    return
  }
  Remove-Item -Recurse -Force $folder
}

function uptime {
  if ($PSVersionTable.PSVersion.Major -eq 5) {
    Get-WmiObject win32_operatingsystem | Select-Object @{Name = 'LastBootUpTime'; Expression = { $_.ConverttoDateTime($_.lastbootuptime) } } | Format-Table -HideTableHeaders
  }
  else {
    net statistics workstation | Select-String "since" | ForEach-Object { $_.ToString().Replace('Statistics since ', '') }
  }
}

function pkill ($process) {
  if (-not $process) {
    Write-Error "Error: Please provide a process name to kill."
    return
  }
  Get-Process -Name $process -ErrorAction SilentlyContinue | Stop-Process -Force
}

function pgrep ($process) {
  if (-not $process) {
    Write-Error "Error: Please provide a process name to search for."
    return
  }
  Get-Process -Name $process -ErrorAction SilentlyContinue
}

function sysinfo { Get-ComputerInfo }

function Edit-Profile {
  vim $PROFILE.CurrentUserAllHosts
}

function Update-Profile {
  . $PROFILE
}
