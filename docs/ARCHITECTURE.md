# ARCHITECTURE

## Design goal

`khon-party` is a command-first, zero-config package for Claude Code.

The end-user path should stay minimal:

1. install once
2. restart Claude Code
3. use `/khon-party`

## Runtime boundary

The installed runtime is still a single self-contained file:

```text
khon-v1/commands/khon-party.md
```

That file is copied to:

```text
~/.claude/commands/khon-party.md
```

## Authoring model

Editable source now lives under:

```text
src/
```

Key source areas:
- `src/command/` — main command fragments
- `src/prompts/personas/` — persona cards
- `src/prompts/modules/` — full curated KHON cognitive module prompts
- `src/prompts/templates/` — debate/governance/synthesis templates
- `scripts/build_runtime.py` — generates the single-file runtime

## Build flow

1. edit source files in `src/`
2. run `python3 scripts/build_runtime.py`
3. generated runtime is written to `khon-v1/commands/khon-party.md`
4. `install.sh` builds, installs, and verifies

## Why this structure

This keeps both goals true:

- end users still get one installed command file
- maintainers can edit prompts in smaller files

## Runtime flow

The command follows this high-level sequence:

1. infer objective from arguments or conversation context
2. parse optional overrides
3. derive 3-5 personas
4. choose a dynamic subset of cognitive modules
5. run a visible party-style discussion
6. apply a governance gate
7. return a friendlier final synthesis and safe next steps
