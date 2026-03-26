#!/usr/bin/env bash
set -euo pipefail

OWNER="Ima8"
REPO="khon-party"
DEFAULT_REF="main"
REF="${KHON_PARTY_REF:-${1:-$DEFAULT_REF}}"
RAW_BASE="https://raw.githubusercontent.com/${OWNER}/${REPO}/${REF}"
RUNTIME_URL="${KHON_PARTY_RUNTIME_URL:-${RAW_BASE}/khon-v1/commands/khon-party.md}"
VERIFY_URL="${KHON_PARTY_VERIFY_URL:-${RAW_BASE}/verify-install.sh}"
MARKETPLACE_URL="${KHON_PARTY_MARKETPLACE_URL:-${RAW_BASE}/.claude-plugin/marketplace.json}"
PLUGIN_MANIFEST_URL="${KHON_PARTY_PLUGIN_MANIFEST_URL:-${RAW_BASE}/plugins/khon-party/.claude-plugin/plugin.json}"
PLUGIN_MORE_URL="${KHON_PARTY_PLUGIN_MORE_URL:-${RAW_BASE}/plugins/khon-party/skills/more/SKILL.md}"
PLUGIN_MAX_URL="${KHON_PARTY_PLUGIN_MAX_URL:-${RAW_BASE}/plugins/khon-party/skills/max/SKILL.md}"
CLAUDE_DIR="${HOME}/.claude"
COMMANDS_DIR="${CLAUDE_DIR}/commands"
TARGET_FILE="${COMMANDS_DIR}/khon-party.md"
BACKUP_DIR="${CLAUDE_DIR}/backups/khon-party"
TMP_DIR="$(mktemp -d)"
TMP_RUNTIME_DIR="${TMP_DIR}/khon-v1/commands"
TMP_MARKETPLACE_DIR="${TMP_DIR}/.claude-plugin"
TMP_PLUGIN_DIR="${TMP_DIR}/plugins/khon-party"
TMP_RUNTIME="${TMP_RUNTIME_DIR}/khon-party.md"
TMP_VERIFY="${TMP_DIR}/verify-install.sh"
TMP_MARKETPLACE_FILE="${TMP_MARKETPLACE_DIR}/marketplace.json"
TMP_PLUGIN_MANIFEST_FILE="${TMP_PLUGIN_DIR}/.claude-plugin/plugin.json"
TMP_PLUGIN_MORE_FILE="${TMP_PLUGIN_DIR}/skills/more/SKILL.md"
TMP_PLUGIN_MAX_FILE="${TMP_PLUGIN_DIR}/skills/max/SKILL.md"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
MARKETPLACE_SOURCE="${KHON_PARTY_MARKETPLACE_SOURCE:-${TMP_DIR}}"

if [ -n "${KHON_PARTY_MARKETPLACE_SOURCE:-}" ]; then
  MARKETPLACE_SOURCE_LABEL="${KHON_PARTY_MARKETPLACE_SOURCE}"
else
  MARKETPLACE_SOURCE_LABEL="downloaded marketplace bundle from ${OWNER}/${REPO} (${REF})"
fi

cleanup() {
  rm -rf "${TMP_DIR}"
}
trap cleanup EXIT

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

require_command() {
  command -v "$1" >/dev/null 2>&1 || fail "$1 is required for remote install"
}

download() {
  local url="$1"
  local output="$2"

  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$url" -o "$output"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$output" "$url"
  else
    fail 'curl or wget is required for remote install'
  fi
}

add_marketplace() {
  if [[ "${MARKETPLACE_SOURCE}" = /* || "${MARKETPLACE_SOURCE}" = ./* || "${MARKETPLACE_SOURCE}" = ../* ]]; then
    claude plugin marketplace add "${MARKETPLACE_SOURCE}" --scope user
  else
    claude plugin marketplace add "${MARKETPLACE_SOURCE}" --scope user --sparse .claude-plugin plugins
  fi
}

assert_plugin_installed() {
  local plugin_list
  plugin_list="$(claude plugin list --json 2>/dev/null || true)"
  printf '%s\n' "${plugin_list}" | grep -Fq "\"id\": \"${PLUGIN_ID}\"" || fail "Installed plugin not found in Claude plugin list: ${PLUGIN_ID}"
  printf '%s\n' "${plugin_list}" | grep -F -A6 "\"id\": \"${PLUGIN_ID}\"" | grep -Fq '"enabled": true' || fail "Plugin is installed but not enabled: ${PLUGIN_ID}"
  ok "Installed and enabled plugin ${PLUGIN_ID}"
}

MARKETPLACE_NAME="${KHON_PARTY_MARKETPLACE_NAME:-khon-party}"
PLUGIN_NAME="${KHON_PARTY_PLUGIN_NAME:-khon-party}"
PLUGIN_ID="${PLUGIN_NAME}@${MARKETPLACE_NAME}"

info "Installing khon-party command family from ${OWNER}/${REPO} (${REF})"
require_command claude
mkdir -p "${COMMANDS_DIR}"
mkdir -p "${BACKUP_DIR}"
mkdir -p "${TMP_RUNTIME_DIR}"
mkdir -p "${TMP_MARKETPLACE_DIR}"
mkdir -p "${TMP_PLUGIN_DIR}/.claude-plugin"
mkdir -p "${TMP_PLUGIN_DIR}/skills/more"
mkdir -p "${TMP_PLUGIN_DIR}/skills/max"

info "Downloading base runtime"
download "${RUNTIME_URL}" "${TMP_RUNTIME}"

info "Downloading verifier"
download "${VERIFY_URL}" "${TMP_VERIFY}"
chmod +x "${TMP_VERIFY}"

info "Downloading marketplace bundle"
download "${MARKETPLACE_URL}" "${TMP_MARKETPLACE_FILE}"
download "${PLUGIN_MANIFEST_URL}" "${TMP_PLUGIN_MANIFEST_FILE}"
download "${PLUGIN_MORE_URL}" "${TMP_PLUGIN_MORE_FILE}"
download "${PLUGIN_MAX_URL}" "${TMP_PLUGIN_MAX_FILE}"

info "Validating downloaded base runtime"
"${TMP_VERIFY}" "${TMP_RUNTIME}" --base-only

if [ -f "${TARGET_FILE}" ]; then
  cp "${TARGET_FILE}" "${BACKUP_DIR}/khon-party.md.${TIMESTAMP}.bak"
  ok "Backed up existing base command to ${BACKUP_DIR}/khon-party.md.${TIMESTAMP}.bak"
fi

cp "${TMP_RUNTIME}" "${TARGET_FILE}"
chmod 0644 "${TARGET_FILE}"
ok "Installed base command to ${TARGET_FILE}"

info "Registering khon-party marketplace"
add_marketplace

info "Installing namespaced plugin commands"
claude plugin install "${PLUGIN_ID}" --scope user
assert_plugin_installed

info "Validating installed command family"
"${TMP_VERIFY}" --full "${TARGET_FILE}"

cat <<EOF

Remote install complete.

Installed commands:
- /khon-party
- /khon-party:more
- /khon-party:max

Installed base command from:
- ${RUNTIME_URL}

Installed plugin from marketplace source:
- ${MARKETPLACE_SOURCE_LABEL}

Next steps:
1. Restart Claude Code
2. If Claude Code is already open, you can also run:

   /reload-plugins

3. Use the full command family:

   /khon-party
   /khon-party:more
   /khon-party:max

Notes:
- This installer uses Claude Code's official marketplace and plugin install commands
- It downloads the generated marketplace and plugin files before registering the plugin
- The base command is installed at ~/.claude/commands/khon-party.md
- The namespaced commands are installed as the user-scope plugin ${PLUGIN_ID}
- It does not write directly into Claude plugin cache directories
EOF
