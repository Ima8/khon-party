# VERIFICATION

Use this checklist to verify `khon-party` without changing the runtime design.

## 1. Static checks

Confirm the repo contains:

- `khon-v1/commands/khon-party.md`
- `install.sh`
- `uninstall.sh`
- `verify-install.sh`
- support docs/specs/examples

Confirm the runtime file includes:

- command overview
- pre-flight inference rules
- dynamic personas
- dynamic module subset selection
- visible debate
- governance gate
- final synthesis

## 2. Install verification

Run:

```bash
./install.sh
./verify-install.sh
```

Expected result:

- `~/.claude/commands/khon-party.md` exists
- required sections are present
- examples are printed after verification

## 3. Registration checks in Claude Code

Before behavioral testing, confirm the command is actually discoverable.

### Check 0: command discovery

After restarting Claude Code:

```text
/skills
```

Or type `/` and confirm `/khon-party` appears in the picker.

Notes:
- custom commands are best verified through `/skills` or slash autocomplete
- if `/khon-party` is missing, inspect the installed file frontmatter first
- `argument-hint` values that contain `[]` should be quoted so the frontmatter remains valid YAML

## 4. Behavioral checks in Claude Code

### Case 1: help

```text
/khon-party help
```

Check that it:
- explains what the command does
- shows default behavior
- shows optional controls
- shows short usage examples

### Case 2: direct prompt

```text
/khon-party วิเคราะห์ระบบนี้ในมุม dev + biz + governance
```

Check that it:
- infers objective
- derives multiple personas
- shows visible debate
- returns synthesis

### Case 3: no arguments

```text
/khon-party
```

Check that it:
- uses recent conversation context
- does not start with a setup wizard
- asks a clarifying question only if blocked

### Case 4: deep debate

```text
/khon-party [depth=deep] เปรียบเทียบ 3 ทางเลือกนี้
```

Check that it:
- adds a meaningful convergence round when disagreement remains
- makes trade-offs explicit

### Case 5: forced modules

```text
/khon-party [modules=cog.role_playing,cog.six_thinking_hats,cog.black_swan] วิเคราะห์โจทย์นี้
```

Check that it:
- respects the explicit module override
- still applies governance before the final recommendation

### Case 6: risky scenario

Use a prompt with meaningful downside or governance concerns.

Check that it:
- labels recommendations as safe / caution / risky
- reframes risky advice instead of presenting it as unquestioned action

## Pass criteria

- one-command UX remains simple
- command infers before asking
- output includes debate and synthesis
- governance is visible and separate from synthesis
- advanced controls remain optional
