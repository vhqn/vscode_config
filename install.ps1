# install.ps1 — Link Windows VSCode config files
# Usage: .\install.ps1   (auto-elevates if not admin)

# Self-elevate if not running as admin
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Requesting administrator privileges..."
    Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SrcDir = Join-Path $ScriptDir "win_vscode"
$TargetDir = "$env:APPDATA\Code\User"

if (-not (Test-Path $TargetDir)) {
    Write-Host "[error] VSCode User directory not found: $TargetDir"
    Write-Host "Make sure VSCode is installed and has been launched at least once."
    pause
    exit 1
}

$ConfigFiles = @("keybindings.json", "settings.json")

Write-Host "==> Linking VSCode config..."

foreach ($file in $ConfigFiles) {
    $Src = Join-Path $SrcDir $file
    $Dst = Join-Path $TargetDir $file

    if (-not (Test-Path $Src)) {
        Write-Host "  [skip] source not found: $Src"
        continue
    }

    $item = Get-Item $Dst -ErrorAction SilentlyContinue
    if ($item -and $item.LinkType -ne "SymbolicLink") {
        Write-Host "  [backup] $Dst -> $Dst.bak"
        Move-Item $Dst "$Dst.bak" -Force
    }

    New-Item -ItemType SymbolicLink -Path $Dst -Target $Src -Force | Out-Null
    Write-Host "  [linked] $Src -> $Dst"
}

Write-Host ""
Write-Host "Done! Restart VSCode if it is already open."
pause
