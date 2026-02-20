#!/bin/bash

# Zed Configuration Restore Script
# Restores Zed configuration from this directory

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZED_CONFIG="$HOME/.config/zed"
BACKUP_SETTINGS="$SCRIPT_DIR/settings.json"

echo "Starting Zed configuration restore..."

# Check if backup exists
if [ ! -f "$BACKUP_SETTINGS" ]; then
    echo "Error: Backup configuration not found at $BACKUP_SETTINGS"
    echo "Run backup.sh first to create a backup."
    exit 1
fi

# Warn if Zed is running
if pgrep -x "Zed" > /dev/null; then
    echo "⚠️  Warning: Zed is currently running."
    echo "The restore will work better if you quit Zed first."
    read -p "Do you want to continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Restore cancelled."
        exit 0
    fi
fi

# Create config directory if it doesn't exist
mkdir -p "$ZED_CONFIG"

# Backup existing config before overwriting
if [ -f "$ZED_CONFIG/settings.json" ]; then
    echo "Creating safety backup of current configuration..."
    cp "$ZED_CONFIG/settings.json" "$ZED_CONFIG/settings.json.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Restore settings.json
echo "Restoring settings.json..."
cp "$BACKUP_SETTINGS" "$ZED_CONFIG/settings.json"

# Restore keymap.json if it exists in backup
if [ -f "$SCRIPT_DIR/keymap.json" ]; then
    echo "Restoring keymap.json..."
    cp "$SCRIPT_DIR/keymap.json" "$ZED_CONFIG/keymap.json"
fi

# Restore themes if they exist in backup
if [ -d "$SCRIPT_DIR/themes" ]; then
    echo "Restoring custom themes..."
    mkdir -p "$ZED_CONFIG/themes"
    cp -r "$SCRIPT_DIR/themes/"* "$ZED_CONFIG/themes/"
fi

# Restore snippets if they exist in backup
if [ -d "$SCRIPT_DIR/snippets" ]; then
    echo "Restoring snippets..."
    mkdir -p "$ZED_CONFIG/snippets"
    cp -r "$SCRIPT_DIR/snippets/"* "$ZED_CONFIG/snippets/"
fi

# Restore tasks.json if it exists in backup
if [ -f "$SCRIPT_DIR/tasks.json" ]; then
    echo "Restoring tasks.json..."
    cp "$SCRIPT_DIR/tasks.json" "$ZED_CONFIG/tasks.json"
fi

echo "✓ Restore completed successfully!"
if pgrep -x "Zed" > /dev/null; then
    echo "Restart Zed to see all changes take effect."
else
    echo "Launch Zed to use the restored configuration."
fi
