#!/usr/bin/env bash
# install.sh — Link vscode/keybindings.json to VSCode on macOS/Linux

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$DOTFILES_DIR/vscode/keybindings.json"

# Detect OS
OS="$(uname -s)"

if [[ "$OS" == "Darwin" ]]; then
  APP_DIRS=(
    "$HOME/Library/Application Support/Code/User"
  )
elif [[ "$OS" == "Linux" ]]; then
  APP_DIRS=(
    "$HOME/.config/Code/User"
  )
else
  echo "Unsupported OS: $OS"
  exit 1
fi

link_file() {
  local dst="$1"
  local dir
  dir="$(dirname "$dst")"

  if [[ ! -d "$dir" ]]; then
    echo "  [skip] directory not found: $dir"
    return
  fi

  # Backup if a real file (not already a symlink)
  if [[ -e "$dst" && ! -L "$dst" ]]; then
    echo "  [backup] $dst -> $dst.bak"
    mv "$dst" "$dst.bak"
  fi

  ln -sf "$SRC" "$dst"
  echo "  [linked] $dst"
}

echo "==> Linking keybindings.json ..."
for dir in "${APP_DIRS[@]}"; do
  link_file "$dir/keybindings.json"
done

echo ""
echo "Done! Restart VSCode if it is already open."
