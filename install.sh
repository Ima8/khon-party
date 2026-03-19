#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"
COMMANDS_DIR="${CLAUDE_DIR}/commands"
TARGET_FILE="${COMMANDS_DIR}/khon-party.md"
SOURCE_FILE="${SCRIPT_DIR}/khon-v1/commands/khon-party.md"
BACKUP_DIR="${CLAUDE_DIR}/backups/khon-party"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

info() {
  printf 'ℹ %s\n' "$1"
}

ok() {
  printf '✓ %s\n' "$1"
}

fail() {
  printf '✗ %s\n' "$1" >&2
  exit 1
}

command -v python3 >/dev/null 2>&1 || fail "python3 is required to build the runtime"

info "Building generated runtime"
python3 "${SCRIPT_DIR}/scripts/build_runtime.py"

[ -f "${SOURCE_FILE}" ] || fail "Generated runtime not found: ${SOURCE_FILE}"

mkdir -p "${COMMANDS_DIR}"
mkdir -p "${BACKUP_DIR}"

if [ -f "${TARGET_FILE}" ]; then
  cp "${TARGET_FILE}" "${BACKUP_DIR}/khon-party.md.${TIMESTAMP}.bak"
  ok "Backed up existing command to ${BACKUP_DIR}/khon-party.md.${TIMESTAMP}.bak"
fi

cp "${SOURCE_FILE}" "${TARGET_FILE}"
chmod 0644 "${TARGET_FILE}"
ok "Installed command to ${TARGET_FILE}"

if [ -x "${SCRIPT_DIR}/verify-install.sh" ]; then
  info "Running install verification"
  "${SCRIPT_DIR}/verify-install.sh"
fi

cat <<'EOF'

Next steps:
1. Restart Claude Code
2. Try one of these:

   /khon-party วิเคราะห์โจทย์นี้ในมุม dev + biz + governance
   /khon-party

Advanced help lives in:
- docs/EXAMPLES.md
- docs/MANUAL-INSTALL.md
EOF
