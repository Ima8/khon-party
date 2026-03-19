# CLAUDE.md

This repo packages a standalone Claude Code command.

## Core rule

- Runtime v1 lives in `khon-v1/commands/khon-party.md`.
- That file must stay self-contained.
- Do not introduce runtime dependencies on `docs/`, `prompts/`, `skills/`, or `specs/`.
- Support files exist for maintainability, review, and iteration only.

## Product intent

- zero-config first
- infer from prompt/context before asking
- visible debate before synthesis
- governance before risky advice
- advanced controls hidden in help/docs

## Editing guidance

- Keep `/khon-party` easy: install once, restart Claude Code, use one command.
- Prefer editing the existing runtime file over adding loaders, config files, or extra install targets.
- If a change makes the first-run UX more complicated, reject it.
- If a change is useful only for advanced users, keep it in docs/examples rather than the main runtime path.
- When evolving prompts/specs, sync the final behavior back into `khon-v1/commands/khon-party.md`.

## Install target

- `~/.claude/commands/khon-party.md`

## Verification

- `./verify-install.sh` validates the installed command after `./install.sh`.
