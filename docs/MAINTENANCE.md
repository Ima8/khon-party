# MAINTENANCE

## Source of truth

Editable source lives under:

```text
src/
```

Generated runtime artifact lives at:

```text
khon-v1/commands/khon-party.md
```

Installed runtime target remains:

```text
~/.claude/commands/khon-party.md
```

## Safe editing workflow

1. edit source files in `src/`
2. run `python3 scripts/build_runtime.py`
3. review generated `khon-v1/commands/khon-party.md`
4. run a smoke test with `install.sh`, `verify-install.sh`, and `uninstall.sh`
5. confirm the user-facing flow is still simple

## Guardrails

Do not:

- add a first-run setup wizard
- require config files for normal use
- split runtime behavior across multiple installed files
- hide debate and return only a neat summary
- bypass governance for risky recommendations
- hand-edit the generated runtime as the primary editing path

## Frontmatter rules

The generated command frontmatter must stay valid YAML.

Important rule:
- quote `argument-hint` when it contains bracket-heavy syntax such as `[personas=...] [modules=...]`

Example:

```yaml
argument-hint: "[personas=a,b,c] [modules=x,y] [depth=light|standard|deep] [help] <prompt>"
```

If frontmatter becomes invalid, Claude Code may skip command registration entirely.

## Review checklist

Before shipping a change, confirm:

- `/khon-party` still works with no arguments
- advanced controls are optional, not required
- runtime is still self-contained
- install target is still `~/.claude/commands/khon-party.md`
- generated runtime includes embedded persona/module/template sections
- support docs match the actual runtime behavior
