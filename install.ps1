# install.ps1 — 将 vscode/keybindings.json 链接到 Windows 上的 VSCode 配置目录
# 需要管理员权限运行，或者在 Windows 设置中开启开发者模式（允许创建符号链接）

param()  # 脚本参数入口；当前为空，表示不接收额外参数

$ErrorActionPreference = "Stop"  # 遇到错误立即停止执行

$DotfilesDir = Split-Path -Parent $MyInvocation.MyCommand.Path  # 当前脚本所在目录
$Src = Join-Path $DotfilesDir "vscode\keybindings.json"          # 源 keybindings.json 路径

$Targets = @{
    "VSCode" = "$env:APPDATA\Code\User\keybindings.json"  # VSCode 用户级快捷键配置目标路径
}

function Link-File {
    param([string]$App, [string]$Dst)  # App: 应用名称；Dst: 目标文件完整路径

    $Dir = Split-Path -Parent $Dst  # 提取目标目录路径

    if (-not (Test-Path $Dir)) {
        Write-Host "  [skip] directory not found: $Dir"  # 目录不存在则跳过
        return  # 提前返回，避免后续创建链接失败
    }

    # 若目标是普通文件（不是符号链接），先备份，避免覆盖用户原配置
    $item = Get-Item $Dst -ErrorAction SilentlyContinue  # 目标不存在时静默处理
    if ($item -and $item.LinkType -ne "SymbolicLink") {
        Write-Host "  [backup] $Dst -> $Dst.bak"  # 提示备份路径
        Move-Item $Dst "$Dst.bak" -Force  # 原文件重命名为 .bak
    }

    New-Item -ItemType SymbolicLink -Path $Dst -Target $Src -Force | Out-Null  # 创建/覆盖符号链接
    Write-Host "  [linked] $Dst"  # 输出链接完成信息
}

Write-Host "==> Linking keybindings.json ..."  # 开始执行提示
foreach ($app in $Targets.Keys) {
    Link-File -App $app -Dst $Targets[$app]  # 遍历并链接所有目标
}

Write-Host ""  # 输出空行，便于阅读日志
Write-Host "Done! Restart VSCode if it is already open."  # 执行完成提示
