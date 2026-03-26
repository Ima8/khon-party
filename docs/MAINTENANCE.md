# MAINTENANCE

## Source of truth

Editable source lives under:

```text
src/
```

Generated runtime family lives at:

```text
khon-v1/commands/khon-party.md
plugins/khon-party/skills/more/SKILL.md
plugins/khon-party/skills/max/SKILL.md
```

Base install target remains:

```text
~/.claude/commands/khon-party.md
```

Plugin metadata lives at:

```text
.claude-plugin/marketplace.json
plugins/khon-party/.claude-plugin/plugin.json
```

## Safe editing workflow

1. edit source files in `src/`
2. run `python3 scripts/build_runtime.py`
3. review generated `khon-v1/commands/khon-party.md`
4. review generated `plugins/khon-party/skills/more/SKILL.md`
5. review generated `plugins/khon-party/skills/max/SKILL.md`
6. run a smoke test with `install.sh`, `verify-install.sh`, and `uninstall.sh`
7. confirm `claude plugin marketplace list --json` and `claude plugin list --json` show the expected installed state during the smoke test
8. if testing unpublished local plugin changes from a checkout, `claude --plugin-dir /path/to/khon-party/plugins/khon-party` is still a valid shortcut
9. confirm the user-facing flow is still simple

## Guardrails

Do not:

- add a first-run setup wizard
- require config files for normal use
- duplicate runtime logic across separate handwritten mode files
- hide debate and return only a neat summary
- bypass governance for risky recommendations
- hand-edit the generated runtime files as the primary editing path
- tell users to write directly into Claude plugin cache directories

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
- `/khon-party:more` and `/khon-party:max` are generated and discoverable when the plugin is loaded
- advanced controls are optional, not required
- runtime family is still generated from shared source rather than hand-maintained copies
- base install target is still `~/.claude/commands/khon-party.md`
- generated runtime files include embedded persona/module/template sections
- support docs match the actual command-family behavior
