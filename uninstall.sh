#!/usr/bin/env bash
set -euo pipefail

CLAUDE_DIR="${HOME}/.claude"
COMMANDS_DIR="${CLAUDE_DIR}/commands"
TARGET_FILE="${COMMANDS_DIR}/khon-party.md"
BACKUP_DIR="${CLAUDE_DIR}/backups/khon-party"
MARKETPLACE_NAME="khon-party"
PLUGIN_NAME="khon-party"
PLUGIN_ID="${PLUGIN_NAME}@${MARKETPLACE_NAME}"

info() {
  printf 'ℹ %s\n' "$1"
}

ok() {
  printf '✓ %s\n' "$1"
}

plugin_installed() {
  command -v claude >/dev/null 2>&1 || return 1
  claude plugin list --json 2>/dev/null | grep -Fq "\"id\": \"${PLUGIN_ID}\""
}

marketplace_declared() {
  command -v claude >/dev/null 2>&1 || return 1
  claude plugin marketplace list --json 2>/dev/null | grep -Fq "\"name\": \"${MARKETPLACE_NAME}\""
}

if [ -f "${TARGET_FILE}" ]; then
  rm -f "${TARGET_FILE}"
  ok "Removed ${TARGET_FILE}"
else
  info "No installed khon-party base command found at ${TARGET_FILE}"
fi

if plugin_installed; then
  claude plugin uninstall "${PLUGIN_ID}" --scope user
  ok "Removed plugin ${PLUGIN_ID}"
else
  info "No installed khon-party plugin found at user scope"
fi

if marketplace_declared; then
  claude plugin marketplace remove "${MARKETPLACE_NAME}"
  ok "Removed marketplace ${MARKETPLACE_NAME}"
else
  info "No configured khon-party marketplace found"
fi

if [ -d "${BACKUP_DIR}" ]; then
  LATEST_BACKUP="$(ls -1t "${BACKUP_DIR}" 2>/dev/null | head -n 1 || true)"
  if [ -n "${LATEST_BACKUP}" ]; then
    cp "${BACKUP_DIR}/${LATEST_BACKUP}" "${TARGET_FILE}"
    ok "Restored previous base command from ${BACKUP_DIR}/${LATEST_BACKUP}"
  fi
fi

cat <<'EOF'

Uninstall complete.

What this removed:
- the base command installed at ~/.claude/commands/khon-party.md
- the user-scope plugin khon-party@khon-party when present
- the configured khon-party marketplace when present

What this did not remove:
- generated plugin source files in this repo
- plugin cache or data belonging to other plugins

If Claude Code was open, restart it or run /reload-plugins before testing command removal.
EOF
