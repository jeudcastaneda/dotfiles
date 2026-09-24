#!/usr/bin/env bash
# Back up Work, personal, Cursor, and migration kit for Mac migration.
# Usage:
#   DISK="/Volumes/MySSD/mac-migrate-20260923" ./backup-to-ssd.sh
#   ./backup-to-ssd.sh   # auto-detect external volume or use ~/personal/4_Archives/mac-migrate-20260923
set -euo pipefail

MIGRATE_DATE="${MIGRATE_DATE:-20260923}"
STAMP="mac-migrate-${MIGRATE_DATE}"

detect_disk() {
  if [[ -n "${DISK:-}" ]]; then
    echo "$DISK"
    return
  fi
  local vol name
  for vol in /Volumes/*; do
    name="$(basename "$vol")"
    [[ "$name" == "Macintosh HD" ]] && continue
    [[ "$name" == "Macintosh HD - Data" ]] && continue
    [[ -d "$vol" ]] || continue
    echo "${vol}/${STAMP}"
    return
  done
  # Never under ~/personal — personal rsync would recurse into the backup tree.
  echo "${HOME}/${STAMP}"
}

DISK="$(detect_disk)"
mkdir -p "$DISK"/{work-backup,personal-backup,cursor-migrate,migration-kit,secrets-encrypted}

echo "Backup root: $DISK"
echo "Tip: Quit Cursor before cursor backup for a consistent state.vscdb."

# --- Work ---
rsync -aH --progress \
  "${HOME}/Work" "${DISK}/work-backup/"

rsync -aH --progress \
  --exclude '*.dmg' --exclude '*.xip' --exclude 'Xcode_*' \
  --exclude '*.pkg' \
  "${HOME}/Downloads" "${DISK}/work-backup/"

find "${HOME}/Work" -maxdepth 3 -name .git -type d 2>/dev/null \
  | while read -r g; do
      d="$(dirname "$g")"
      echo "=== $d ==="
      git -C "$d" remote -v 2>/dev/null || true
    done > "${DISK}/migration-kit/git-remotes.txt"

# --- Personal ---
rsync -aH --progress \
  --exclude "${STAMP}" \
  --exclude '4_Archives/mac-migrate-*' \
  "${HOME}/personal" "${DISK}/personal-backup/"

mkdir -p "${DISK}/personal-backup/Documents"
rsync -aH --progress \
  "${HOME}/Documents/Notes" "${HOME}/Documents/personal_backup" \
  "${DISK}/personal-backup/Documents/" 2>/dev/null || true

mkdir -p "${DISK}/personal-backup/home-config"
for f in .zshrc .zprofile .zshenv .p10k.zsh .vimrc .ideavimrc \
  .gitconfig .gitconfig-work .gitconfig-personal .gitignore_global; do
  [[ -e "${HOME}/$f" ]] && rsync -aH "${HOME}/$f" "${DISK}/personal-backup/home-config/"
done
for cfg in nvim tmux aerospace lazygit iterm2; do
  [[ -d "${HOME}/.config/$cfg" ]] && rsync -aH --progress \
    "${HOME}/.config/$cfg" "${DISK}/personal-backup/home-config/"
done

# --- Cursor ---
rsync -aH --progress \
  --exclude 'statsig-cache.json' \
  "${HOME}/.cursor/" "${DISK}/cursor-migrate/dot-cursor/"

rsync -aH --progress \
  --exclude 'Cache' --exclude 'CachedData' --exclude 'GPUCache' \
  --exclude 'Code Cache' --exclude 'logs' --exclude 'CachedExtensionVSIXs' \
  --exclude 'machineid' \
  "${HOME}/Library/Application Support/Cursor/User/" \
  "${DISK}/cursor-migrate/CursorUser/"

cp -f "${HOME}/.cursor/mcp.json" "${DISK}/cursor-migrate/mcp.json"
chmod 600 "${DISK}/cursor-migrate/mcp.json"

# --- Migration kit ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "${SCRIPT_DIR}/migration-kit/Brewfile" ]]; then
  rsync -aH "${SCRIPT_DIR}/migration-kit/" "${DISK}/migration-kit/"
fi
if command -v brew >/dev/null 2>&1; then
  brew bundle dump --file="${DISK}/migration-kit/Brewfile" --force 2>/dev/null || true
fi
if [[ -f "${SCRIPT_DIR}/migration-kit/NEW_LAPTOP.md" ]]; then
  cp -f "${SCRIPT_DIR}/migration-kit/NEW_LAPTOP.md" "${DISK}/migration-kit/"
fi

echo ""
echo "Done. Backup root: $DISK"
if [[ "$DISK" == "${HOME}/${STAMP}" ]]; then
  echo "No external volume detected — copy this folder to your SSD when mounted:"
  echo "  rsync -aH --progress \"$DISK/\" \"/Volumes/<YourDisk>/${STAMP}/\""
fi
