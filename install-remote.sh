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
INSTALL_DIR="${KHON_PARTY_INSTALL_DIR:-${CLAUDE_DIR}/marketplaces/khon-party}"
INSTALL_PARENT="$(dirname "${INSTALL_DIR}")"
mkdir -p "${INSTALL_PARENT}"
STAGE_DIR="$(mktemp -d -p "${INSTALL_PARENT}" ".khon-party-staging.XXXXXX")"
STAGE_RUNTIME_DIR="${STAGE_DIR}/khon-v1/commands"
STAGE_MARKETPLACE_DIR="${STAGE_DIR}/.claude-plugin"
STAGE_PLUGIN_DIR="${STAGE_DIR}/plugins/khon-party"
STAGE_RUNTIME="${STAGE_RUNTIME_DIR}/khon-party.md"
STAGE_VERIFY="${STAGE_DIR}/verify-install.sh"
STAGE_MARKETPLACE_FILE="${STAGE_MARKETPLACE_DIR}/marketplace.json"
STAGE_PLUGIN_MANIFEST_FILE="${STAGE_PLUGIN_DIR}/.claude-plugin/plugin.json"
STAGE_PLUGIN_MORE_FILE="${STAGE_PLUGIN_DIR}/skills/more/SKILL.md"
STAGE_PLUGIN_MAX_FILE="${STAGE_PLUGIN_DIR}/skills/max/SKILL.md"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

if [ -n "${KHON_PARTY_MARKETPLACE_SOURCE:-}" ]; then
  MARKETPLACE_SOURCE="${KHON_PARTY_MARKETPLACE_SOURCE}"
  MARKETPLACE_SOURCE_LABEL="${KHON_PARTY_MARKETPLACE_SOURCE}"
  USE_INSTALL_DIR=0
else
  MARKETPLACE_SOURCE="${INSTALL_DIR}"
  MARKETPLACE_SOURCE_LABEL="${INSTALL_DIR} (synced from ${OWNER}/${REPO} ${REF})"
  USE_INSTALL_DIR=1
fi

cleanup_stage() {
  [ -d "${STAGE_DIR}" ] && rm -rf "${STAGE_DIR}"
}
trap cleanup_stage EXIT

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
mkdir -p "${STAGE_RUNTIME_DIR}"
mkdir -p "${STAGE_MARKETPLACE_DIR}"
mkdir -p "${STAGE_PLUGIN_DIR}/.claude-plugin"
mkdir -p "${STAGE_PLUGIN_DIR}/skills/more"
mkdir -p "${STAGE_PLUGIN_DIR}/skills/max"

info "Downloading base runtime"
download "${RUNTIME_URL}" "${STAGE_RUNTIME}"

info "Downloading verifier"
download "${VERIFY_URL}" "${STAGE_VERIFY}"
chmod +x "${STAGE_VERIFY}"

info "Downloading marketplace bundle"
download "${MARKETPLACE_URL}" "${STAGE_MARKETPLACE_FILE}"
download "${PLUGIN_MANIFEST_URL}" "${STAGE_PLUGIN_MANIFEST_FILE}"
download "${PLUGIN_MORE_URL}" "${STAGE_PLUGIN_MORE_FILE}"
download "${PLUGIN_MAX_URL}" "${STAGE_PLUGIN_MAX_FILE}"

info "Validating downloaded base runtime"
"${STAGE_VERIFY}" "${STAGE_RUNTIME}" --base-only

if [ -f "${TARGET_FILE}" ]; then
  cp "${TARGET_FILE}" "${BACKUP_DIR}/khon-party.md.${TIMESTAMP}.bak"
  ok "Backed up existing base command to ${BACKUP_DIR}/khon-party.md.${TIMESTAMP}.bak"
fi

cp "${STAGE_RUNTIME}" "${TARGET_FILE}"
chmod 0644 "${TARGET_FILE}"
ok "Installed base command to ${TARGET_FILE}"

if [ "${USE_INSTALL_DIR}" -eq 1 ]; then
  info "Syncing marketplace bundle to ${INSTALL_DIR}"
  rm -rf "${INSTALL_DIR}"
  mv "${STAGE_DIR}" "${INSTALL_DIR}"
  STAGE_DIR="${INSTALL_DIR}"
  STAGE_VERIFY="${INSTALL_DIR}/verify-install.sh"
  trap - EXIT
  ok "Marketplace bundle ready at ${INSTALL_DIR}"
fi

info "Registering khon-party marketplace"
add_marketplace

info "Installing namespaced plugin commands"
claude plugin install "${PLUGIN_ID}" --scope user
assert_plugin_installed

info "Validating installed command family"
"${STAGE_VERIFY}" --full "${TARGET_FILE}"

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
- The marketplace bundle is synced into ${INSTALL_DIR} (a permanent location under ~/.claude) so Claude Code can revalidate the marketplace across restarts
- Re-running this installer refreshes that bundle in place
- The base command is installed at ~/.claude/commands/khon-party.md
- The namespaced commands are installed as the user-scope plugin ${PLUGIN_ID}
- It does not write directly into Claude plugin cache directories
EOF
