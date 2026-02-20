#!/bin/bash

# iTerm2 Configuration Backup Script
# Backs up iTerm2 configuration to this directory

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ITERM_PLIST="$HOME/Library/Preferences/com.googlecode.iterm2.plist"
ITERM_APP_SUPPORT="$HOME/Library/Application Support/iTerm2"

echo "Starting iTerm2 configuration backup..."

# Check if iTerm2 config exists
if [ ! -f "$ITERM_PLIST" ]; then
    echo "Error: iTerm2 configuration not found at $ITERM_PLIST"
    exit 1
fi

# Convert binary plist to XML for better version control
echo "Backing up iTerm2 preferences..."
plutil -convert xml1 "$ITERM_PLIST" -o "$SCRIPT_DIR/com.googlecode.iterm2.plist"

# Backup DynamicProfiles if they exist
if [ -d "$ITERM_APP_SUPPORT/DynamicProfiles" ] && [ "$(ls -A "$ITERM_APP_SUPPORT/DynamicProfiles")" ]; then
    echo "Backing up Dynamic Profiles..."
    mkdir -p "$SCRIPT_DIR/DynamicProfiles"
    cp -r "$ITERM_APP_SUPPORT/DynamicProfiles/"* "$SCRIPT_DIR/DynamicProfiles/"
else
    echo "No Dynamic Profiles found, skipping..."
fi

# Backup Scripts directory if it exists
if [ -d "$ITERM_APP_SUPPORT/Scripts" ] && [ "$(ls -A "$ITERM_APP_SUPPORT/Scripts")" ]; then
    echo "Backing up Scripts..."
    mkdir -p "$SCRIPT_DIR/Scripts"
    cp -r "$ITERM_APP_SUPPORT/Scripts/"* "$SCRIPT_DIR/Scripts/"
else
    echo "No Scripts found, skipping..."
fi

echo "✓ Backup completed successfully!"
echo "Configuration saved to: $SCRIPT_DIR"
