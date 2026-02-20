# Zed Configuration Backup

This directory contains backup and restore scripts for Zed editor configuration, allowing you to synchronize your Zed setup across multiple Mac computers.

## What's Backed Up

- **Settings**: All Zed preferences, editor settings, language configurations, etc. (`settings.json`)
- **Keymaps**: Custom keyboard shortcuts and bindings (`keymap.json`)
- **Custom Themes**: User-installed themes (if any)
- **Snippets**: Code snippets and templates (if any)
- **Tasks**: Custom task configurations (`tasks.json`)

## Usage

### Backing Up Configuration

On your source Mac (where Zed is configured):

```bash
cd zed
./backup.sh
```

This will:
- Copy your Zed settings to `settings.json`
- Copy custom keymaps, themes, snippets, and tasks (if present)
- Save everything to this directory

After backing up, commit and push the changes to your git repository.

### Restoring Configuration

On your target Mac (where you want to restore the configuration):

1. Clone or pull this repository
2. Run the restore script:

```bash
cd zed
./restore.sh
```

3. Restart Zed to apply all changes

The restore script will:
- Warn you if Zed is currently running
- Create a safety backup of your existing configuration
- Restore all settings, keymaps, and customizations

## Important Notes

- **Quit Zed before restoring**: While the restore can work with Zed running, it's recommended to quit the application first for best results.
- **Safety backups**: The restore script automatically creates a timestamped backup of your current configuration before overwriting.
- **Version control**: Configuration files are stored in JSON format for easy diff viewing in git.
- **Multiple Macs**: You can use this to keep configurations in sync across multiple machines by regularly backing up from your primary Mac and restoring on others.
- **Conversations not backed up**: The `conversations` directory (containing chat history) is intentionally not backed up for privacy reasons.

## File Locations

Zed stores its configuration in:
- `~/.config/zed/settings.json` - Main settings
- `~/.config/zed/keymap.json` - Custom keybindings
- `~/.config/zed/themes/` - Custom themes
- `~/.config/zed/snippets/` - Code snippets
- `~/.config/zed/tasks.json` - Task configurations

## Troubleshooting

**Changes not appearing after restore:**
- Make sure to fully quit and restart Zed
- Check that the restore script completed without errors

**Backup file not found:**
- Run `backup.sh` first to create the initial backup
- Check that you're in the correct directory

**Permission errors:**
- Make sure the scripts are executable: `chmod +x backup.sh restore.sh`

**Zed not found:**
- Ensure Zed is installed and has been launched at least once
- The config directory is created on first launch

## Workflow Example

**Initial setup (on your main Mac):**
```bash
cd ~/Documents/GitHub/mac-config/zed
./backup.sh
git add .
git commit -m "Add Zed configuration"
git push
```

**On another Mac:**
```bash
cd ~/Documents/GitHub/mac-config
git pull
cd zed
./restore.sh
# Restart Zed
```

**Syncing changes:**
```bash
# On main Mac after making changes
./backup.sh
git commit -am "Update Zed config"
git push

# On other Macs
git pull
./restore.sh
# Restart Zed
```

## Customization

If you have additional files or directories in `~/.config/zed/` that you want to back up, you can modify the backup and restore scripts to include them. The scripts are designed to be easily extensible.
