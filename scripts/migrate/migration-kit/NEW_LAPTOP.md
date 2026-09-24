# New Mac setup checklist

Migration backup layout: `mac-migrate-20260923/` with `work-backup/`, `personal-backup/`, `cursor-migrate/`, `migration-kit/`.

On the **old Mac**, backup lands at `~/mac-migrate-20260923` when no external drive is mounted. Copy to SSD:

```bash
~/personal/dotfiles/scripts/migrate/copy-to-external.sh
# or: DISK=/Volumes/<Disk>/mac-migrate-20260923 rsync -aH ~/mac-migrate-20260923/ "$DISK/"
```

Scripts:

- Backup: `DISK=/Volumes/<Disk>/mac-migrate-20260923 ~/personal/dotfiles/scripts/migrate/backup-to-ssd.sh`
- Copy to SSD: `copy-to-external.sh`
- Restore: `DISK=/Volumes/<Disk>/mac-migrate-20260923 ~/personal/dotfiles/scripts/migrate/restore-from-ssd.sh`

## 1. Corporate baseline

1. Complete Jamf / Company Portal enrollment.
2. Install from **Self Service**: Cursor, Chrome, Microsoft Office, Teams, Outlook, OneDrive (optional), GlobalProtect, Xcode, Android platform tools, Postman, PyCharm, Wireshark, Privileges, iTerm2.
3. Connect to VPN and verify internal tools as needed.

## 2. Homebrew and CLI

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew bundle --file=/Volumes/<Disk>/mac-migrate-20260923/migration-kit/Brewfile
```

Manual (if not in Brewfile):

- [oh-my-zsh](https://ohmyz.sh/) + [powerlevel10k](https://github.com/romkatv/powerlevel10k)
- Plugins: `zsh-autosuggestions`, `zsh-syntax-highlighting`, `web-search`
- [SDKMAN](https://sdkman.io/) for Java
- [uv](https://github.com/astral-sh/uv) / Python 3.10
- `fzf` (`brew install fzf` + `$(brew --prefix)/opt/fzf/install`)

## 3. Restore files

Plug in SSD, then either run the restore script or:

```bash
DISK="/Volumes/<YourDisk>/mac-migrate-20260923"
bash ~/personal/dotfiles/scripts/migrate/restore-from-ssd.sh
```

Or manual rsync (same as script):

```bash
rsync -aH "$DISK/work-backup/Work" ~/
ln -sfn ~/Work/3_Resources/code ~/Documents/Codes
rsync -aH "$DISK/personal-backup/personal" ~/
# Copy home-config/* to ~ and ~/.config as in restore-from-ssd.sh
```

**Git:** `~/.gitconfig` uses `includeIf` for `~/personal/` and `~/work/`. Keep `~/Work` paths (macOS is case-insensitive).

## 4. Dotfiles

Active nvim/tmux/aerospace live in `~/personal/dotfiles/.config/`. Symlink or copy into `~/.config/` if restore did not already.

Ensure `.zshrc` has:

- `BASH_PROJECTS="$HOME/Work/3_Resources/code/bash_projects"`
- `PATH` includes `$BASH_PROJECTS/bin`

## 5. Cursor

1. Install Cursor (Self Service). Launch once, then **Quit**.
2. Restore from SSD (restore script does this), or:

```bash
rsync -aH "$DISK/cursor-migrate/dot-cursor/" ~/.cursor/
rsync -aH "$DISK/cursor-migrate/CursorUser/" \
  "$HOME/Library/Application Support/Cursor/User/"
cp "$DISK/cursor-migrate/mcp.json" ~/.cursor/mcp.json
chmod 600 ~/.cursor/mcp.json
ln -sfn ~/Documents/Codes/cursor_rules_and_documentation/rules ~/.cursor/rules
ln -sfn ~/Documents/Codes/cursor_rules_and_documentation/skills ~/.cursor/skills
```

3. Open Cursor → sign in.
4. **File → Open Folder** for each project at the **same path** as the old Mac (`~/Work/op5ios-atm`, `~/personal/dotfiles`, etc.).
5. If chats are missing for a repo: open the project, find new `workspaceStorage/<hash>/`, match `workspace.json` to old hash on SSD, merge old folder contents into the new hash.
6. **MCP** (Settings → MCP): context7, playwright, tts — need Node/npx.
7. Reinstall extensions or use **File → Share → Export Profile** from old Mac if you exported one.
8. Read the Cursor workflow context (also in this kit as `cursor-workflow-new-laptop.md`):

`~/personal/second-brain/06_Research/how-to/cursor-workflow-new-laptop.md`

First chat after restore: ask Cursor to read that file and confirm rules, skills, and MCP.

## 6. SSH and secrets

- Prefer new `ssh-keygen -t ed25519` and add public key to GitHub / Azure DevOps.
- Do **not** put `~/personal`, `~/.ssh`, or `mcp.json` on work OneDrive.
- Optional: mount encrypted `secrets-encrypted/ssh.dmg` from backup if you created one.

## 7. Verification

- [ ] `git status` in `~/Work/op5ios-atm`, `~/Work/requirement_finder`
- [ ] `req`, `run_ts`, `day`, `kp` aliases work
- [ ] `nvim` loads LazyVim config
- [ ] Cursor shows prior chat for one Work repo and one personal repo
- [ ] MCP tools work in Agent
- [ ] Personal data not synced to work cloud

## 8. Repos (if not using full Work rsync)

See `migration-kit/git-remotes.txt` and clone remotes, then copy any uncommitted work from SSD backup.
