#!/usr/bin/env bash
# Copy migration folder from ~/mac-migrate-* to external SSD.
set -euo pipefail
MIGRATE_DATE="${MIGRATE_DATE:-20260923}"
STAMP="mac-migrate-${MIGRATE_DATE}"
SRC="${SRC:-${HOME}/${STAMP}}"

if [[ -z "${DISK:-}" ]]; then
  for vol in /Volumes/*; do
    name="$(basename "$vol")"
    [[ "$name" == "Macintosh HD" ]] && continue
    [[ "$name" == "Macintosh HD - Data" ]] && continue
    [[ -d "$vol" ]] || continue
    DISK="${vol}/${STAMP}"
    break
  done
fi

if [[ -z "${DISK:-}" ]]; then
  echo "Set DISK=/Volumes/YourDrive/${STAMP} or plug in external volume." >&2
  exit 1
fi

[[ -d "$SRC" ]] || { echo "Missing $SRC — run backup-to-ssd.sh first." >&2; exit 1; }
mkdir -p "$DISK"
rsync -aH --progress "$SRC/" "$DISK/"
echo "Copied to $DISK"
