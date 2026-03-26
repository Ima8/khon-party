#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"
COMMANDS_DIR="${CLAUDE_DIR}/commands"
TARGET_FILE="${COMMANDS_DIR}/khon-party.md"
SOURCE_FILE="${SCRIPT_DIR}/khon-v1/commands/khon-party.md"
BACKUP_DIR="${CLAUDE_DIR}/backups/khon-party"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
PLUGIN_DIR="${SCRIPT_DIR}/plugins/khon-party"
MARKETPLACE_FILE="${SCRIPT_DIR}/.claude-plugin/marketplace.json"
MARKETPLACE_NAME="khon-party"
PLUGIN_NAME="khon-party"
PLUGIN_ID="${PLUGIN_NAME}@${MARKETPLACE_NAME}"

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

assert_plugin_installed() {
  local plugin_list
  plugin_list="$(claude plugin list --json 2>/dev/null || true)"
  printf '%s\n' "${plugin_list}" | grep -Fq "\"id\": \"${PLUGIN_ID}\"" || fail "Installed plugin not found in Claude plugin list: ${PLUGIN_ID}"
  printf '%s\n' "${plugin_list}" | grep -F -A6 "\"id\": \"${PLUGIN_ID}\"" | grep -Fq '"enabled": true' || fail "Plugin is installed but not enabled: ${PLUGIN_ID}"
  ok "Installed and enabled plugin ${PLUGIN_ID}"
}

command -v python3 >/dev/null 2>&1 || fail "python3 is required to build the runtime"
command -v claude >/dev/null 2>&1 || fail "claude is required to install the namespaced plugin commands"

info "Building generated command family"
python3 "${SCRIPT_DIR}/scripts/build_runtime.py"

[ -f "${SOURCE_FILE}" ] || fail "Generated base runtime not found: ${SOURCE_FILE}"
[ -f "${PLUGIN_DIR}/skills/more/SKILL.md" ] || fail "Generated plugin skill not found: ${PLUGIN_DIR}/skills/more/SKILL.md"
[ -f "${PLUGIN_DIR}/skills/max/SKILL.md" ] || fail "Generated plugin skill not found: ${PLUGIN_DIR}/skills/max/SKILL.md"
[ -f "${MARKETPLACE_FILE}" ] || fail "Generated marketplace metadata not found: ${MARKETPLACE_FILE}"

mkdir -p "${COMMANDS_DIR}"
mkdir -p "${BACKUP_DIR}"

if [ -f "${TARGET_FILE}" ]; then
  cp "${TARGET_FILE}" "${BACKUP_DIR}/khon-party.md.${TIMESTAMP}.bak"
  ok "Backed up existing base command to ${BACKUP_DIR}/khon-party.md.${TIMESTAMP}.bak"
fi

cp "${SOURCE_FILE}" "${TARGET_FILE}"
chmod 0644 "${TARGET_FILE}"
ok "Installed base command to ${TARGET_FILE}"

info "Registering local khon-party marketplace"
claude plugin marketplace add "${SCRIPT_DIR}" --scope user

info "Installing namespaced plugin commands"
claude plugin install "${PLUGIN_ID}" --scope user
assert_plugin_installed

if [ -x "${SCRIPT_DIR}/verify-install.sh" ]; then
  info "Running install verification"
  "${SCRIPT_DIR}/verify-install.sh"
fi

cat <<EOF

Next steps:
1. Restart Claude Code
2. If Claude Code is already open, you can also run:

   /reload-plugins

3. The full command family is ready now:

   /khon-party
   /khon-party:more
   /khon-party:max

Installed plugin source:
- ${SCRIPT_DIR}

Generated plugin metadata:
- ${MARKETPLACE_FILE}
- ${PLUGIN_DIR}/.claude-plugin/plugin.json

Notes:
- install.sh installs the base command to ~/.claude/commands/khon-party.md
- install.sh also registers this checkout as a Claude marketplace source and installs ${PLUGIN_ID}
- It does not write directly into Claude plugin cache directories
EOF
