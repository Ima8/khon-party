#!/usr/bin/env bash
set -euo pipefail

OWNER="Ima8"
REPO="khon-party"
DEFAULT_REF="main"
REF="${KHON_PARTY_REF:-${1:-$DEFAULT_REF}}"
RAW_BASE="https://raw.githubusercontent.com/${OWNER}/${REPO}/${REF}"
RUNTIME_URL="${KHON_PARTY_RUNTIME_URL:-${RAW_BASE}/khon-v1/commands/khon-party.md}"
VERIFY_URL="${KHON_PARTY_VERIFY_URL:-${RAW_BASE}/verify-install.sh}"
CLAUDE_DIR="${HOME}/.claude"
COMMANDS_DIR="${CLAUDE_DIR}/commands"
TARGET_FILE="${COMMANDS_DIR}/khon-party.md"
BACKUP_DIR="${CLAUDE_DIR}/backups/khon-party"
TMP_DIR="$(mktemp -d)"
TMP_RUNTIME="${TMP_DIR}/khon-party.md"
TMP_VERIFY="${TMP_DIR}/verify-install.sh"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

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

info "Installing khon-party from ${OWNER}/${REPO} (${REF})"
mkdir -p "${COMMANDS_DIR}"
mkdir -p "${BACKUP_DIR}"

info "Downloading runtime"
download "${RUNTIME_URL}" "${TMP_RUNTIME}"

info "Downloading verifier"
download "${VERIFY_URL}" "${TMP_VERIFY}"
chmod +x "${TMP_VERIFY}"

info "Validating downloaded runtime"
"${TMP_VERIFY}" "${TMP_RUNTIME}"

if [ -f "${TARGET_FILE}" ]; then
  cp "${TARGET_FILE}" "${BACKUP_DIR}/khon-party.md.${TIMESTAMP}.bak"
  ok "Backed up existing command to ${BACKUP_DIR}/khon-party.md.${TIMESTAMP}.bak"
fi

cp "${TMP_RUNTIME}" "${TARGET_FILE}"
chmod 0644 "${TARGET_FILE}"
ok "Installed command to ${TARGET_FILE}"

info "Validating installed command"
"${TMP_VERIFY}" "${TARGET_FILE}"

cat <<EOF

Remote install complete.

Installed from:
- ${RUNTIME_URL}

Next steps:
1. Restart Claude Code
2. Try one of these:

   /khon-party วิเคราะห์โจทย์นี้ในมุม dev + biz + governance
   /khon-party
   /khon-party Should we launch this now?
EOF
