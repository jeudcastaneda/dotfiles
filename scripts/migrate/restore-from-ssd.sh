#!/usr/bin/env bash
# Restore Work, personal, home config, and Cursor from migration backup.
# Usage: DISK="/Volumes/MySSD/mac-migrate-20260923" ./restore-from-ssd.sh
set -euo pipefail

MIGRATE_DATE="${MIGRATE_DATE:-20260923}"
STAMP="mac-migrate-${MIGRATE_DATE}"

if [[ -z "${DISK:-}" ]]; then
  for vol in /Volumes/*; do
    name="$(basename "$vol")"
    [[ "$name" == "Macintosh HD" ]] && continue
    [[ -d "${vol}/${STAMP}" ]] && DISK="${vol}/${STAMP}" && break
  done
fi
DISK="${DISK:-${HOME}/${STAMP}}"

if [[ ! -d "${DISK}/work-backup" ]]; then
  echo "Missing backup at ${DISK}. Set DISK= to mac-migrate folder." >&2
  exit 1
fi

echo "Restore from: $DISK"
read -r -p "Continue? This overwrites ~/Work, ~/personal, and Cursor User data. [y/N] " ans
[[ "${ans,,}" == "y" ]] || exit 0

mkdir -p "${HOME}/Documents"
rsync -aH "${DISK}/work-backup/Work" "${HOME}/"
ln -sfn "${HOME}/Work/3_Resources/code" "${HOME}/Documents/Codes"

rsync -aH "${DISK}/work-backup/Downloads" "${HOME}/" 2>/dev/null || true

rsync -aH "${DISK}/personal-backup/personal" "${HOME}/"

if [[ -d "${DISK}/personal-backup/home-config" ]]; then
  for f in "${DISK}/personal-backup/home-config/"*; do
    base="$(basename "$f")"
    if [[ -d "$f" && "$base" != ".*" ]]; then
      mkdir -p "${HOME}/.config"
      rsync -aH "$f" "${HOME}/.config/"
    elif [[ -f "$f" ]]; then
      rsync -aH "$f" "${HOME}/"
    fi
  done
fi

if [[ -d "${DISK}/cursor-migrate/dot-cursor" ]]; then
  rsync -aH "${DISK}/cursor-migrate/dot-cursor/" "${HOME}/.cursor/"
fi
if [[ -f "${DISK}/cursor-migrate/mcp.json" ]]; then
  cp -f "${DISK}/cursor-migrate/mcp.json" "${HOME}/.cursor/mcp.json"
  chmod 600 "${HOME}/.cursor/mcp.json"
fi
if [[ -d "${DISK}/cursor-migrate/CursorUser" ]]; then
  mkdir -p "${HOME}/Library/Application Support/Cursor/User"
  rsync -aH "${DISK}/cursor-migrate/CursorUser/" \
    "${HOME}/Library/Application Support/Cursor/User/"
fi

ln -sfn "${HOME}/Documents/Codes/cursor_rules_and_documentation/rules" "${HOME}/.cursor/rules"
ln -sfn "${HOME}/Documents/Codes/cursor_rules_and_documentation/skills" "${HOME}/.cursor/skills"

echo "Restore complete. Open Cursor, sign in, and open projects from ~/Work and ~/personal paths."
