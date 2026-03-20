#!/usr/bin/env bash
set -euo pipefail

CLAUDE_DIR="${HOME}/.claude"
TARGET_FILE="${1:-${CLAUDE_DIR}/commands/khon-party.md}"

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

[ -f "${TARGET_FILE}" ] || fail "Installed command not found: ${TARGET_FILE}"

REQUIRED_MODULE_COUNT=21
MIN_BYTES=20000

REQUIRED_PATTERNS=(
  '<!-- GENERATED FROM SOURCE FILES. DO NOT EDIT khon-v1/commands/khon-party.md DIRECTLY. -->'
  'You are the KHON Party Orchestrator'
  'description: Zero-config brainstorm-then-debate party analysis using embedded KHON persona and cognitive-module prompt packs'
  'argument-hint:'
  '## Command Overview'
  '## Pre-Flight'
  '## KHON Party Process'
  '## Embedded Persona Cards'
  '### architect'
  '## Generated Module Catalog Summary'
  '## Embedded Cognitive Module Cards'
  '### cog.role_playing'
  '### cog.starbursting'
  '### cog.black_swan'
  '### cog.result_optimisation'
  '### cog.conflict_resolution'
  '### cog.swiss_cheese'
  '## Embedded Debate Templates'
  '## Display Summary to User'
  '## Notes for LLMs'
  '$ARGUMENTS'
)

info "Validating installed command at ${TARGET_FILE}"

if [ ! -r "${TARGET_FILE}" ]; then
  fail "Installed command is not readable: ${TARGET_FILE}"
fi
ok "Installed command is readable"

file_size="$(wc -c < "${TARGET_FILE}")"
if [ "${file_size}" -ge "${MIN_BYTES}" ]; then
  ok "Installed command size looks valid (${file_size} bytes)"
else
  fail "Installed command is unexpectedly small (${file_size} bytes)"
fi

frontmatter_markers="$(grep -c '^---$' "${TARGET_FILE}")"
if [ "${frontmatter_markers}" -ge 2 ]; then
  ok 'YAML frontmatter markers found'
else
  fail 'Missing YAML frontmatter markers'
fi

if grep -Eiq '(<html|404: Not Found|AccessDenied|<!DOCTYPE html>)' "${TARGET_FILE}"; then
  fail 'Installed file looks like an HTML/error response, not the runtime command'
else
  ok 'Installed file does not look like an HTML/error response'
fi

for pattern in "${REQUIRED_PATTERNS[@]}"; do
  if grep -Fq "${pattern}" "${TARGET_FILE}"; then
    ok "Found: ${pattern}"
  else
    fail "Missing required pattern: ${pattern}"
  fi
done

module_count="$(grep -Ec '^### cog\.' "${TARGET_FILE}")"
if [ "${module_count}" -eq "${REQUIRED_MODULE_COUNT}" ]; then
  ok "Found ${module_count} embedded module cards"
else
  fail "Expected ${REQUIRED_MODULE_COUNT} embedded module cards, found ${module_count}"
fi

cat <<'EOF'

Verification passed.

Try in Claude Code:
- /khon-party วิเคราะห์แผนนี้ในมุม dev + biz + governance
- /khon-party
- /khon-party [modules=cog.starbursting,cog.black_swan,cog.result_optimisation] [depth=deep] เปรียบเทียบ 3 ทางเลือกนี้

If Claude Code was already open, restart it first.
EOF
