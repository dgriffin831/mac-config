# Neovim Configuration Backup

This directory contains backup and restore scripts for Neovim configuration, allowing you to synchronize your Neovim setup across multiple Mac computers.

## What's Backed Up

- **Init file**: Main configuration (`init.lua` or `init.vim`)
- **Lua modules**: Custom Lua configuration in `lua/` directory
- **Plugins**: Plugin configurations in `plugin/` directory
- **After scripts**: Late-loading configs in `after/` directory
- **Filetype plugins**: Custom filetype configs in `ftplugin/` directory
- **Snippets**: Custom snippets in `snippets/` directory
- **Plugin lockfile**: `lazy-lock.json` (for lazy.nvim plugin manager)
- **Other configs**: `ginit.vim`, `stylua.toml`, `.luarc.json`, etc.

**Not backed up:**
- Plugin files themselves (these are managed by your plugin manager)
- Cache and temporary files
- LSP servers and external tools

## Usage

### Backing Up Configuration

On your source Mac (where Neovim is configured):

```bash
cd nvim
./backup.sh
```

This will:
- Copy all configuration files from `~/.config/nvim/` to the `config/` directory
- Preserve directory structure
- Include plugin lockfiles to ensure consistent plugin versions

After backing up, commit and push the changes to your git repository.

### Restoring Configuration

On your target Mac (where you want to restore the configuration):

1. Ensure Neovim is installed: `brew install neovim`
2. Clone or pull this repository
3. Run the restore script:

```bash
cd nvim
./restore.sh
```

4. Open Neovim and install plugins:
   - For **lazy.nvim**: `:Lazy sync`
   - For **packer.nvim**: `:PackerSync`
   - For **vim-plug**: `:PlugInstall`

The restore script will:
- Warn you if Neovim is currently running
- Create a timestamped backup of your existing configuration
- Restore all configuration files and directories
- Preserve the exact directory structure

## Important Notes

- **Plugin managers**: This backup includes your plugin configuration and lockfiles, but not the plugins themselves. After restoring, you'll need to run your plugin manager's install command.
- **Safety backups**: The restore script automatically creates a timestamped backup (e.g., `~/.config/nvim-backup-20240219_104500`) before overwriting.
- **Version control**: Configuration files are stored as-is for easy diff viewing in git.
- **LSP and external tools**: Language servers, formatters, and linters are not backed up. You'll need to reinstall them on new machines.
- **Multiple Macs**: Keep configurations in sync by regularly backing up from your primary Mac and restoring on others.

## File Locations

Neovim stores its configuration in:
- `~/.config/nvim/` - Main configuration directory
- `~/.config/nvim/init.lua` or `init.vim` - Entry point
- `~/.config/nvim/lua/` - Lua modules
- `~/.config/nvim/plugin/` - Plugin configurations
- `~/.local/share/nvim/` - Plugins, cache (not backed up)
- `~/.local/state/nvim/` - State files (not backed up)

## Troubleshooting

**"No configuration found" error:**
- Configure Neovim first by creating `~/.config/nvim/init.lua` or `init.vim`
- Launch Neovim at least once to create the config directory

**Plugins not working after restore:**
- Open Neovim and run your plugin manager's install command
- For lazy.nvim: `:Lazy sync`
- For packer.nvim: `:PackerSync`
- Check that plugin managers are properly configured in your init file

**LSP/Formatter errors:**
- Reinstall language servers: `:Mason` (if using mason.nvim)
- Or manually install with `brew`, `npm`, `pip`, etc.

**Permission errors:**
- Make sure scripts are executable: `chmod +x backup.sh restore.sh`

**Backup missing directories:**
- The scripts only back up directories that exist in your config
- Empty directories are skipped automatically

## Workflow Example

**Initial setup (on your main Mac):**
```bash
cd ~/Documents/GitHub/mac-config/nvim
./backup.sh
git add .
git commit -m "Add Neovim configuration"
git push
```

**On another Mac:**
```bash
# Install Neovim if needed
brew install neovim

# Restore config
cd ~/Documents/GitHub/mac-config
git pull
cd nvim
./restore.sh

# Open Neovim and install plugins
nvim
# Then run: :Lazy sync (or your plugin manager's command)
```

**Syncing changes:**
```bash
# On main Mac after making changes
./backup.sh
git commit -am "Update Neovim config"
git push

# On other Macs
git pull
./restore.sh
# Reopen Neovim, may need to sync plugins
```

## Plugin Managers

This backup system works with all popular Neovim plugin managers:

- **lazy.nvim**: Lockfile (`lazy-lock.json`) is backed up to ensure consistent versions
- **packer.nvim**: Configuration in `plugin/packer.lua` is backed up
- **vim-plug**: Configuration in `init.vim` is backed up

After restoring, always run your plugin manager's sync command to install plugins.

## Customization

If you have additional files or directories in `~/.config/nvim/` that you want to back up, you can modify the backup and restore scripts. Look for the loop that backs up additional config files and add your filenames there.
