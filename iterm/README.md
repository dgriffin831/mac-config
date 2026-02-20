# iTerm2 Configuration Backup

This directory contains backup and restore scripts for iTerm2 configuration, allowing you to synchronize your iTerm2 setup across multiple Mac computers.

## What's Backed Up

- **Main preferences**: All iTerm2 settings, profiles, color schemes, key bindings, etc.
- **Dynamic Profiles**: Custom profile configurations (if any)
- **Scripts**: Python scripts and automation (if any)

## Usage

### Backing Up Configuration

On your source Mac (where iTerm2 is configured):

```bash
cd iterm
./backup.sh
```

This will:
- Export your iTerm2 preferences to `com.googlecode.iterm2.plist` (in XML format for version control)
- Copy any Dynamic Profiles and Scripts
- Save everything to this directory

After backing up, commit and push the changes to your git repository.

### Restoring Configuration

On your target Mac (where you want to restore the configuration):

1. Clone or pull this repository
2. Run the restore script:

```bash
cd iterm
./restore.sh
```

3. Restart iTerm2 to apply all changes

The restore script will:
- Warn you if iTerm2 is currently running
- Create a safety backup of your existing configuration
- Restore all preferences, profiles, and settings
- Restore Dynamic Profiles and Scripts (if backed up)

## Important Notes

- **Quit iTerm2 before restoring**: While the restore can work with iTerm2 running, it's recommended to quit the application first for best results.
- **Safety backups**: The restore script automatically creates a timestamped backup of your current configuration before overwriting.
- **Version control**: The preferences are stored in XML format (converted from binary plist) for better diff viewing in git.
- **Multiple Macs**: You can use this to keep configurations in sync across multiple machines by regularly backing up from your primary Mac and restoring on others.

## File Locations

iTerm2 stores its configuration in:
- `~/Library/Preferences/com.googlecode.iterm2.plist` - Main preferences
- `~/Library/Application Support/iTerm2/DynamicProfiles/` - Dynamic profiles
- `~/Library/Application Support/iTerm2/Scripts/` - Python scripts

## Troubleshooting

**Changes not appearing after restore:**
- Make sure to fully quit and restart iTerm2
- Check that the restore script completed without errors

**Backup file not found:**
- Run `backup.sh` first to create the initial backup
- Check that you're in the correct directory

**Permission errors:**
- Make sure the scripts are executable: `chmod +x backup.sh restore.sh`

## Workflow Example

**Initial setup (on your main Mac):**
```bash
cd ~/Documents/GitHub/mac-config/iterm
./backup.sh
git add .
git commit -m "Add iTerm2 configuration"
git push
```

**On another Mac:**
```bash
cd ~/Documents/GitHub/mac-config
git pull
cd iterm
./restore.sh
# Restart iTerm2
```

**Syncing changes:**
```bash
# On main Mac after making changes
./backup.sh
git commit -am "Update iTerm2 config"
git push

# On other Macs
git pull
./restore.sh
# Restart iTerm2
```
