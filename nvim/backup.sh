#!/bin/bash

# Neovim Configuration Backup Script
# Backs up Neovim configuration to this directory

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_CONFIG="$HOME/.config/nvim"

echo "Starting Neovim configuration backup..."

# Check if Neovim config exists
if [ ! -d "$NVIM_CONFIG" ]; then
    echo "Error: Neovim configuration not found at $NVIM_CONFIG"
    echo "Please configure Neovim first, then run this script."
    exit 1
fi

# Create backup directory structure
mkdir -p "$SCRIPT_DIR/config"

# Backup init.lua or init.vim
if [ -f "$NVIM_CONFIG/init.lua" ]; then
    echo "Backing up init.lua..."
    cp "$NVIM_CONFIG/init.lua" "$SCRIPT_DIR/config/init.lua"
elif [ -f "$NVIM_CONFIG/init.vim" ]; then
    echo "Backing up init.vim..."
    cp "$NVIM_CONFIG/init.vim" "$SCRIPT_DIR/config/init.vim"
else
    echo "Warning: No init.lua or init.vim found"
fi

# Backup lua directory if it exists
if [ -d "$NVIM_CONFIG/lua" ]; then
    echo "Backing up lua directory..."
    mkdir -p "$SCRIPT_DIR/config/lua"
    cp -r "$NVIM_CONFIG/lua/"* "$SCRIPT_DIR/config/lua/" 2>/dev/null || true
fi

# Backup plugin directory if it exists
if [ -d "$NVIM_CONFIG/plugin" ]; then
    echo "Backing up plugin directory..."
    mkdir -p "$SCRIPT_DIR/config/plugin"
    cp -r "$NVIM_CONFIG/plugin/"* "$SCRIPT_DIR/config/plugin/" 2>/dev/null || true
fi

# Backup after directory if it exists
if [ -d "$NVIM_CONFIG/after" ]; then
    echo "Backing up after directory..."
    mkdir -p "$SCRIPT_DIR/config/after"
    cp -r "$NVIM_CONFIG/after/"* "$SCRIPT_DIR/config/after/" 2>/dev/null || true
fi

# Backup ftplugin directory if it exists
if [ -d "$NVIM_CONFIG/ftplugin" ]; then
    echo "Backing up ftplugin directory..."
    mkdir -p "$SCRIPT_DIR/config/ftplugin"
    cp -r "$NVIM_CONFIG/ftplugin/"* "$SCRIPT_DIR/config/ftplugin/" 2>/dev/null || true
fi

# Backup snippets if they exist
if [ -d "$NVIM_CONFIG/snippets" ]; then
    echo "Backing up snippets..."
    mkdir -p "$SCRIPT_DIR/config/snippets"
    cp -r "$NVIM_CONFIG/snippets/"* "$SCRIPT_DIR/config/snippets/" 2>/dev/null || true
fi

# Backup lazy-lock.json (lazy.nvim plugin manager)
if [ -f "$NVIM_CONFIG/lazy-lock.json" ]; then
    echo "Backing up lazy-lock.json..."
    cp "$NVIM_CONFIG/lazy-lock.json" "$SCRIPT_DIR/config/lazy-lock.json"
fi

# Backup other common config files
for file in ginit.vim stylua.toml .luarc.json .stylua.toml; do
    if [ -f "$NVIM_CONFIG/$file" ]; then
        echo "Backing up $file..."
        cp "$NVIM_CONFIG/$file" "$SCRIPT_DIR/config/$file"
    fi
done

echo "✓ Backup completed successfully!"
echo "Configuration saved to: $SCRIPT_DIR/config"
