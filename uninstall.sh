#!/usr/bin/env bash
set -euo pipefail

CLAUDE_DIR="${HOME}/.claude"
COMMANDS_DIR="${CLAUDE_DIR}/commands"
TARGET_FILE="${COMMANDS_DIR}/khon-party.md"
BACKUP_DIR="${CLAUDE_DIR}/backups/khon-party"

info() {
  printf 'ℹ %s\n' "$1"
}

ok() {
  printf '✓ %s\n' "$1"
}

if [ -f "${TARGET_FILE}" ]; then
  rm -f "${TARGET_FILE}"
  ok "Removed ${TARGET_FILE}"
else
  info "No installed khon-party command found at ${TARGET_FILE}"
fi

if [ -d "${BACKUP_DIR}" ]; then
  LATEST_BACKUP="$(ls -1t "${BACKUP_DIR}" 2>/dev/null | head -n 1 || true)"
  if [ -n "${LATEST_BACKUP}" ]; then
    cp "${BACKUP_DIR}/${LATEST_BACKUP}" "${TARGET_FILE}"
    ok "Restored previous command from ${BACKUP_DIR}/${LATEST_BACKUP}"
  fi
fi

cat <<'EOF'

Uninstall complete.
If Claude Code was open, restart it before testing command removal.
EOF
