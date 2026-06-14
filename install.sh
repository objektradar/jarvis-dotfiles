#!/bin/bash
# Jarvis Dotfiles Installer
set -e
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Jarvis Dotfiles ==="

# Backup existing configs
backup() {
    [ -f "$1" ] && cp "$1" "${1}.bak.$(date +%Y%m%d)" && echo "  backed up $1"
}

# Bashrc
backup ~/.bashrc
cp "$REPO_DIR/.bashrc" ~/.bashrc
echo "  ✅ ~/.bashrc"

# Neovim
mkdir -p ~/.config/nvim
backup ~/.config/nvim/init.vim
cp "$REPO_DIR/.config/nvim/init.vim" ~/.config/nvim/init.vim
echo "  ✅ ~/.config/nvim/init.vim"

# Atuin
mkdir -p ~/.config/atuin
backup ~/.config/atuin/config.toml
cp "$REPO_DIR/.config/atuin/config.toml" ~/.config/atuin/config.toml
echo "  ✅ ~/.config/atuin/config.toml"

# Bin scripts
if [ -d "$REPO_DIR/bin" ] && [ "$(ls -A $REPO_DIR/bin)" ]; then
    mkdir -p ~/.local/bin
    cp "$REPO_DIR/bin/"* ~/.local/bin/ 2>/dev/null
    chmod +x ~/.local/bin/*
    echo "  ✅ ~/.local/bin/ updated"
fi

echo "=== Done ==="
