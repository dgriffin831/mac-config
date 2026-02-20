#!/bin/bash

# Neovim Configuration Restore Script
# Restores Neovim configuration from this directory

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_CONFIG="$HOME/.config/nvim"
BACKUP_DIR="$SCRIPT_DIR/config"

echo "Starting Neovim configuration restore..."

# Check if backup exists
if [ ! -d "$BACKUP_DIR" ]; then
    echo "Error: Backup configuration not found at $BACKUP_DIR"
    echo "Run backup.sh first to create a backup."
    exit 1
fi

# Warn if Neovim is running
if pgrep -x "nvim" > /dev/null; then
    echo "⚠️  Warning: Neovim is currently running."
    echo "The restore will work better if you quit Neovim first."
    read -p "Do you want to continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Restore cancelled."
        exit 0
    fi
fi

# Create config directory if it doesn't exist
mkdir -p "$NVIM_CONFIG"

# Backup existing config before overwriting
if [ -d "$NVIM_CONFIG" ] && [ "$(ls -A "$NVIM_CONFIG")" ]; then
    echo "Creating safety backup of current configuration..."
    BACKUP_NAME="nvim-backup-$(date +%Y%m%d_%H%M%S)"
    cp -r "$NVIM_CONFIG" "$HOME/.config/$BACKUP_NAME"
    echo "Current config backed up to: ~/.config/$BACKUP_NAME"
fi

# Restore init.lua or init.vim
if [ -f "$BACKUP_DIR/init.lua" ]; then
    echo "Restoring init.lua..."
    cp "$BACKUP_DIR/init.lua" "$NVIM_CONFIG/init.lua"
elif [ -f "$BACKUP_DIR/init.vim" ]; then
    echo "Restoring init.vim..."
    cp "$BACKUP_DIR/init.vim" "$NVIM_CONFIG/init.vim"
fi

# Restore lua directory if it exists in backup
if [ -d "$BACKUP_DIR/lua" ]; then
    echo "Restoring lua directory..."
    mkdir -p "$NVIM_CONFIG/lua"
    cp -r "$BACKUP_DIR/lua/"* "$NVIM_CONFIG/lua/" 2>/dev/null || true
fi

# Restore plugin directory if it exists in backup
if [ -d "$BACKUP_DIR/plugin" ]; then
    echo "Restoring plugin directory..."
    mkdir -p "$NVIM_CONFIG/plugin"
    cp -r "$BACKUP_DIR/plugin/"* "$NVIM_CONFIG/plugin/" 2>/dev/null || true
fi

# Restore after directory if it exists in backup
if [ -d "$BACKUP_DIR/after" ]; then
    echo "Restoring after directory..."
    mkdir -p "$NVIM_CONFIG/after"
    cp -r "$BACKUP_DIR/after/"* "$NVIM_CONFIG/after/" 2>/dev/null || true
fi

# Restore ftplugin directory if it exists in backup
if [ -d "$BACKUP_DIR/ftplugin" ]; then
    echo "Restoring ftplugin directory..."
    mkdir -p "$NVIM_CONFIG/ftplugin"
    cp -r "$BACKUP_DIR/ftplugin/"* "$NVIM_CONFIG/ftplugin/" 2>/dev/null || true
fi

# Restore snippets if they exist in backup
if [ -d "$BACKUP_DIR/snippets" ]; then
    echo "Restoring snippets..."
    mkdir -p "$NVIM_CONFIG/snippets"
    cp -r "$BACKUP_DIR/snippets/"* "$NVIM_CONFIG/snippets/" 2>/dev/null || true
fi

# Restore lazy-lock.json if it exists in backup
if [ -f "$BACKUP_DIR/lazy-lock.json" ]; then
    echo "Restoring lazy-lock.json..."
    cp "$BACKUP_DIR/lazy-lock.json" "$NVIM_CONFIG/lazy-lock.json"
fi

# Restore other config files
for file in ginit.vim stylua.toml .luarc.json .stylua.toml; do
    if [ -f "$BACKUP_DIR/$file" ]; then
        echo "Restoring $file..."
        cp "$BACKUP_DIR/$file" "$NVIM_CONFIG/$file"
    fi
done

echo "✓ Restore completed successfully!"
echo "Launch Neovim to use the restored configuration."
echo ""
echo "Note: If you use a plugin manager, you may need to run plugin install commands:"
echo "  - lazy.nvim: Open nvim and run :Lazy sync"
echo "  - packer.nvim: Open nvim and run :PackerSync"
echo "  - vim-plug: Open nvim and run :PlugInstall"
