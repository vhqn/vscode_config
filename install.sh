#!/usr/bin/env bash
# install.sh — Link macOS VSCode config files
# Usage: ./install.sh
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$DOTFILES_DIR/mac_vscode"

OS="$(uname -s)"

if [[ "$OS" == "Darwin" ]]; then
  TARGET_DIR="$HOME/Library/Application Support/Code/User"
elif [[ "$OS" == "Linux" ]]; then
  TARGET_DIR="$HOME/.config/Code/User"
else
  echo "Unsupported OS: $OS"
  exit 1
fi

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "[error] VSCode User directory not found: $TARGET_DIR"
  echo "Make sure VSCode is installed and has been launched at least once."
  exit 1
fi

echo "==> Linking VSCode config..."

CONFIG_FILES=("keybindings.json" "settings.json")

for file in "${CONFIG_FILES[@]}"; do
  src="$SRC_DIR/$file"
  dst="$TARGET_DIR/$file"

  if [[ ! -f "$src" ]]; then
    echo "  [skip] source not found: $src"
    continue
  fi

  if [[ -e "$dst" && ! -L "$dst" ]]; then
    echo "  [backup] $dst -> $dst.bak"
    mv "$dst" "$dst.bak"
  fi

  ln -sf "$src" "$dst"
  echo "  [linked] $src -> $dst"
done

echo ""
echo "Done! Restart VSCode if it is already open."
