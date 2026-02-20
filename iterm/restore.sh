#!/bin/bash

# iTerm2 Configuration Restore Script
# Restores iTerm2 configuration from this directory

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ITERM_PLIST="$HOME/Library/Preferences/com.googlecode.iterm2.plist"
ITERM_APP_SUPPORT="$HOME/Library/Application Support/iTerm2"
BACKUP_PLIST="$SCRIPT_DIR/com.googlecode.iterm2.plist"

echo "Starting iTerm2 configuration restore..."

# Check if backup exists
if [ ! -f "$BACKUP_PLIST" ]; then
    echo "Error: Backup configuration not found at $BACKUP_PLIST"
    echo "Run backup.sh first to create a backup."
    exit 1
fi

# Warn if iTerm2 is running
if pgrep -x "iTerm2" > /dev/null; then
    echo "⚠️  Warning: iTerm2 is currently running."
    echo "The restore will work better if you quit iTerm2 first."
    read -p "Do you want to continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Restore cancelled."
        exit 0
    fi
fi

# Backup existing config before overwriting
if [ -f "$ITERM_PLIST" ]; then
    echo "Creating safety backup of current configuration..."
    cp "$ITERM_PLIST" "$ITERM_PLIST.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Restore preferences
echo "Restoring iTerm2 preferences..."
cp "$BACKUP_PLIST" "$ITERM_PLIST"

# Restore DynamicProfiles if they exist in backup
if [ -d "$SCRIPT_DIR/DynamicProfiles" ]; then
    echo "Restoring Dynamic Profiles..."
    mkdir -p "$ITERM_APP_SUPPORT/DynamicProfiles"
    cp -r "$SCRIPT_DIR/DynamicProfiles/"* "$ITERM_APP_SUPPORT/DynamicProfiles/"
fi

# Restore Scripts if they exist in backup
if [ -d "$SCRIPT_DIR/Scripts" ]; then
    echo "Restoring Scripts..."
    mkdir -p "$ITERM_APP_SUPPORT/Scripts"
    cp -r "$SCRIPT_DIR/Scripts/"* "$ITERM_APP_SUPPORT/Scripts/"
fi

# Reload iTerm2 preferences
if pgrep -x "iTerm2" > /dev/null; then
    echo "Reloading iTerm2 preferences..."
    defaults read com.googlecode.iterm2 > /dev/null 2>&1 || true
fi

echo "✓ Restore completed successfully!"
echo "If iTerm2 is running, restart it to see all changes take effect."
