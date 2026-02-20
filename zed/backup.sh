#!/bin/bash

# Zed Configuration Backup Script
# Backs up Zed configuration to this directory

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZED_CONFIG="$HOME/.config/zed"

echo "Starting Zed configuration backup..."

# Check if Zed config exists
if [ ! -d "$ZED_CONFIG" ]; then
    echo "Error: Zed configuration not found at $ZED_CONFIG"
    exit 1
fi

# Backup settings.json
if [ -f "$ZED_CONFIG/settings.json" ]; then
    echo "Backing up settings.json..."
    cp "$ZED_CONFIG/settings.json" "$SCRIPT_DIR/settings.json"
else
    echo "Warning: settings.json not found, skipping..."
fi

# Backup keymap.json if it exists
if [ -f "$ZED_CONFIG/keymap.json" ]; then
    echo "Backing up keymap.json..."
    cp "$ZED_CONFIG/keymap.json" "$SCRIPT_DIR/keymap.json"
else
    echo "No keymap.json found, skipping..."
fi

# Backup themes directory if it exists and has content
if [ -d "$ZED_CONFIG/themes" ] && [ "$(ls -A "$ZED_CONFIG/themes")" ]; then
    echo "Backing up custom themes..."
    mkdir -p "$SCRIPT_DIR/themes"
    cp -r "$ZED_CONFIG/themes/"* "$SCRIPT_DIR/themes/"
else
    echo "No custom themes found, skipping..."
fi

# Backup snippets directory if it exists and has content
if [ -d "$ZED_CONFIG/snippets" ] && [ "$(ls -A "$ZED_CONFIG/snippets")" ]; then
    echo "Backing up snippets..."
    mkdir -p "$SCRIPT_DIR/snippets"
    cp -r "$ZED_CONFIG/snippets/"* "$SCRIPT_DIR/snippets/"
else
    echo "No snippets found, skipping..."
fi

# Backup tasks.json if it exists
if [ -f "$ZED_CONFIG/tasks.json" ]; then
    echo "Backing up tasks.json..."
    cp "$ZED_CONFIG/tasks.json" "$SCRIPT_DIR/tasks.json"
else
    echo "No tasks.json found, skipping..."
fi

echo "✓ Backup completed successfully!"
echo "Configuration saved to: $SCRIPT_DIR"
