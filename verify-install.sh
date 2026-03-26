#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"
VERIFY_MODE="full"
TARGET_FILE=""
MARKETPLACE_NAME="khon-party"
PLUGIN_NAME="khon-party"
PLUGIN_ID="${PLUGIN_NAME}@${MARKETPLACE_NAME}"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --base-only)
      VERIFY_MODE="base-only"
      shift
      ;;
    --installed-full)
      VERIFY_MODE="installed-full"
      shift
      ;;
    --full)
      VERIFY_MODE="full"
      shift
      ;;
    -h|--help)
      cat <<'EOF'
Usage: ./verify-install.sh [--base-only|--installed-full|--full] [target-file]

Modes:
- --base-only       Verify only the base command artifact/file
- --installed-full  Verify the installed base command plus installed marketplace/plugin state
- --full            Verify the installed base command, installed marketplace/plugin state, and generated repo artifacts (default)
EOF
      exit 0
      ;;
    *)
      if [ -n "${TARGET_FILE}" ]; then
        printf '✗ Unexpected extra argument: %s\n' "$1" >&2
        exit 1
      fi
      TARGET_FILE="$1"
      shift
      ;;
  esac
done

TARGET_FILE="${TARGET_FILE:-${CLAUDE_DIR}/commands/khon-party.md}"
BASE_RUNTIME_FILE="${SCRIPT_DIR}/khon-v1/commands/khon-party.md"
PLUGIN_MANIFEST_FILE="${SCRIPT_DIR}/plugins/khon-party/.claude-plugin/plugin.json"
PLUGIN_MORE_FILE="${SCRIPT_DIR}/plugins/khon-party/skills/more/SKILL.md"
PLUGIN_MAX_FILE="${SCRIPT_DIR}/plugins/khon-party/skills/max/SKILL.md"
MARKETPLACE_FILE="${SCRIPT_DIR}/.claude-plugin/marketplace.json"

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

assert_file() {
  local file="$1"
  [ -f "${file}" ] || fail "Required file not found: ${file}"
  [ -r "${file}" ] || fail "Required file is not readable: ${file}"
  ok "Found ${file}"
}

assert_pattern() {
  local file="$1"
  local pattern="$2"
  if grep -Fq -- "${pattern}" "${file}"; then
    ok "Found in $(basename "${file}"): ${pattern}"
  else
    fail "Missing required pattern in ${file}: ${pattern}"
  fi
}

assert_no_html_error() {
  local file="$1"
  if grep -Eiq '(<html|404: Not Found|AccessDenied|<!DOCTYPE html>)' "${file}"; then
    fail "File looks like an HTML/error response, not the expected artifact: ${file}"
  fi
  ok "File does not look like an HTML/error response: $(basename "${file}")"
}

verify_base_command() {
  local file="$1"
  local required_module_count=21
  local min_bytes=20000
  local base_required_patterns=(
    '<!-- GENERATED FROM SOURCE FILES. DO NOT EDIT khon-v1/commands/khon-party.md DIRECTLY. -->'
    '## Runtime Entry Point'
    '- canonical command: `/khon-party`'
    '- fixed mode: balanced default'
    'You are the KHON Party Orchestrator'
    'description: "Zero-config brainstorm-then-debate party analysis using embedded KHON persona and cognitive-module prompt packs"'
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

  info "Validating base command at ${file}"
  [ -f "${file}" ] || fail "Base command not found: ${file}"
  [ -r "${file}" ] || fail "Base command is not readable: ${file}"
  ok "Base command is readable"

  local file_size
  file_size="$(wc -c < "${file}")"
  if [ "${file_size}" -ge "${min_bytes}" ]; then
    ok "Base command size looks valid (${file_size} bytes)"
  else
    fail "Base command is unexpectedly small (${file_size} bytes)"
  fi

  local frontmatter_markers
  frontmatter_markers="$(grep -c '^---$' "${file}")"
  if [ "${frontmatter_markers}" -ge 2 ]; then
    ok 'YAML frontmatter markers found in base command'
  else
    fail 'Missing YAML frontmatter markers in base command'
  fi

  assert_no_html_error "${file}"

  local pattern
  for pattern in "${base_required_patterns[@]}"; do
    assert_pattern "${file}" "${pattern}"
  done

  local module_count
  module_count="$(grep -Ec '^### cog\.' "${file}")"
  if [ "${module_count}" -eq "${required_module_count}" ]; then
    ok "Found ${module_count} embedded module cards in base command"
  else
    fail "Expected ${required_module_count} embedded module cards in base command, found ${module_count}"
  fi
}

verify_plugin_repo_artifacts() {
  local more_required_patterns=(
    '<!-- GENERATED FROM SOURCE FILES. DO NOT EDIT plugins/khon-party/skills/more/SKILL.md DIRECTLY. -->'
    '- canonical command: `/khon-party:more`'
    '- fixed mode: `:more`'
    'Treat this entrypoint exactly as if the user explicitly supplied `[:more]`'
    'This is the canonical expanded-selective entrypoint; users should prefer `/khon-party:more`'
  )

  local max_required_patterns=(
    '<!-- GENERATED FROM SOURCE FILES. DO NOT EDIT plugins/khon-party/skills/max/SKILL.md DIRECTLY. -->'
    '- canonical command: `/khon-party:max`'
    '- fixed mode: `:max`'
    'Treat this entrypoint exactly as if the user explicitly supplied `[:max]`'
    'This is the canonical strongest entrypoint; users should prefer `/khon-party:max`'
    'all 21 embedded cognitive modules'
    'roughly 8-9 personas'
    'roughly 50-70 turns'
  )

  info 'Validating generated repo artifacts'
  assert_file "${BASE_RUNTIME_FILE}"
  assert_file "${PLUGIN_MANIFEST_FILE}"
  assert_file "${PLUGIN_MORE_FILE}"
  assert_file "${PLUGIN_MAX_FILE}"
  assert_file "${MARKETPLACE_FILE}"

  assert_no_html_error "${BASE_RUNTIME_FILE}"
  assert_no_html_error "${PLUGIN_MORE_FILE}"
  assert_no_html_error "${PLUGIN_MAX_FILE}"

  assert_pattern "${PLUGIN_MANIFEST_FILE}" '"name": "khon-party"'
  assert_pattern "${PLUGIN_MANIFEST_FILE}" '"author"'
  assert_pattern "${MARKETPLACE_FILE}" '"source": "./plugins/khon-party"'
  assert_pattern "${MARKETPLACE_FILE}" '"name": "Issaret Prachitmutita"'
  assert_pattern "${MARKETPLACE_FILE}" '"metadata"'
  assert_pattern "${MARKETPLACE_FILE}" '"description": "KHON Party marketplace metadata for the namespaced Claude Code plugin variants."'

  local pattern
  for pattern in "${more_required_patterns[@]}"; do
    assert_pattern "${PLUGIN_MORE_FILE}" "${pattern}"
  done

  for pattern in "${max_required_patterns[@]}"; do
    assert_pattern "${PLUGIN_MAX_FILE}" "${pattern}"
  done
}

verify_installed_plugin_state() {
  command -v claude >/dev/null 2>&1 || fail 'claude is required to verify installed marketplace and plugin state'

  local marketplace_list
  local plugin_list

  info 'Validating installed marketplace state'
  marketplace_list="$(claude plugin marketplace list --json 2>/dev/null || true)"
  printf '%s\n' "${marketplace_list}" | grep -Fq "\"name\": \"${MARKETPLACE_NAME}\"" || fail "Configured marketplace not found: ${MARKETPLACE_NAME}"
  ok "Configured marketplace ${MARKETPLACE_NAME} is present"

  info 'Validating installed plugin state'
  plugin_list="$(claude plugin list --json 2>/dev/null || true)"
  printf '%s\n' "${plugin_list}" | grep -Fq "\"id\": \"${PLUGIN_ID}\"" || fail "Installed plugin not found: ${PLUGIN_ID}"
  ok "Installed plugin ${PLUGIN_ID} is present"
  printf '%s\n' "${plugin_list}" | grep -F -A6 "\"id\": \"${PLUGIN_ID}\"" | grep -Fq '"enabled": true' || fail "Plugin is installed but not enabled: ${PLUGIN_ID}"
  ok "Installed plugin ${PLUGIN_ID} is enabled"
}

verify_base_command "${TARGET_FILE}"

case "${VERIFY_MODE}" in
  full)
    verify_plugin_repo_artifacts
    verify_installed_plugin_state
    ;;
  installed-full)
    verify_installed_plugin_state
    ;;
esac

if [ "${VERIFY_MODE}" = "base-only" ]; then
  cat <<'EOF'

Verification passed.

Base-only verification:
- the target khon-party base command file is valid
- this mode is safe for remote pre-install checks
EOF
elif [ "${VERIFY_MODE}" = "installed-full" ]; then
  cat <<'EOF'

Verification passed.

Installed command family verification:
- ~/.claude/commands/khon-party.md is installed and valid
- the khon-party marketplace is configured
- the user-scope plugin khon-party@khon-party is installed and enabled

Try in Claude Code after restart or after running /reload-plugins:
- /khon-party help
- /khon-party:more Compare these options with broader debate pressure
- /khon-party:max Pressure-test this decision with the fullest mode
EOF
else
  cat <<'EOF'

Verification passed.

Base install verification:
- ~/.claude/commands/khon-party.md is installed and valid

Installed plugin verification:
- the khon-party marketplace is configured
- the user-scope plugin khon-party@khon-party is installed and enabled

Plugin source verification:
- .claude-plugin/marketplace.json
- plugins/khon-party/.claude-plugin/plugin.json
- plugins/khon-party/skills/more/SKILL.md
- plugins/khon-party/skills/max/SKILL.md

Try in Claude Code after restart or after running /reload-plugins:
- /khon-party help
- /khon-party:more Compare these options with broader debate pressure
- /khon-party:max Pressure-test this decision with the fullest mode
EOF
fi
