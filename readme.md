# vscode_config

个人 VSCode 快捷键配置，通过 Git 管理，支持 macOS / Windows 跨设备同步。

## 仓库结构

```
vscode_config/
├── vscode/
│   └── keybindings.json   # 快捷键配置（唯一维护的文件）
├── install.sh             # macOS / Linux 安装脚本
├── install.ps1            # Windows 安装脚本
└── README.md
```

安装脚本会在 VSCode 配置目录中创建一个**符号链接**指向本仓库中的文件。之后每次 `git pull` 拉取最新配置，VSCode 会立即生效，无需手动复制。

---

## 新电脑首次安装

### macOS / Linux

```bash
git clone git@github.com:YOUR_USERNAME/vscode_config.git ~/vscode_config
cd ~/vscode_config
chmod +x install.sh
./install.sh
```

### Windows（以管理员身份运行 PowerShell）

```powershell
git clone git@github.com:YOUR_USERNAME/vscode_config.git $HOME\vscode_config
cd $HOME\vscode_config
.\install.ps1
```

> **Windows 提示：** 如果不想每次用管理员权限，可在  
> **设置 → 隐私和安全性 → 开发者选项** 中开启**开发人员模式**，  
> 开启后普通用户也可以创建符号链接。

安装完成后，如果 VSCode 已经打开，重启一次即可生效。

---

## 日常使用

### 修改快捷键

直接在 VSCode 中通过 **Preferences: Open Keyboard Shortcuts (JSON)** 打开并编辑，或者直接编辑 `vscode/keybindings.json`。由于配置文件是符号链接，在编辑器里的修改会直接写回仓库文件中。

### 推送到 GitHub

```bash
cd ~/vscode_config
git add vscode/keybindings.json
git commit -m "keybindings: 添加 X 快捷键"
git push
```

### 在另一台电脑同步

```bash
cd ~/vscode_config
git pull
# VSCode 立即读取新配置，无需重启
```

---

## 跨平台快捷键写法

一份 `keybindings.json` 可以同时兼容 macOS 和 Windows，使用 `when` 条件区分平台：

```jsonc
[
  // macOS
  { "key": "cmd+k cmd+s",  "command": "workbench.action.openGlobalKeybindings", "when": "isMac" },

  // Windows / Linux
  { "key": "ctrl+k ctrl+s", "command": "workbench.action.openGlobalKeybindings", "when": "isWindows || isLinux" }
]
```

---

## 各平台配置路径参考

| 平台    | VSCode 配置目录                                        |
|---------|--------------------------------------------------------|
| macOS   | `~/Library/Application Support/Code/User/`             |
| Windows | `%APPDATA%\Code\User\`                                 |
| Linux   | `~/.config/Code/User/`                                 |

安装脚本会自动检测操作系统并链接到对应路径。
