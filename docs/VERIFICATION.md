# VERIFICATION

Use this checklist to verify the `khon-party` command family.

## 1. Static checks

Confirm the repo contains:

- `khon-v1/commands/khon-party.md`
- `.claude-plugin/marketplace.json`
- `plugins/khon-party/.claude-plugin/plugin.json`
- `plugins/khon-party/skills/more/SKILL.md`
- `plugins/khon-party/skills/max/SKILL.md`
- `install.sh`
- `uninstall.sh`
- `verify-install.sh`
- support docs/specs/examples

Confirm the generated runtime files include:

- command overview
- pre-flight inference rules
- dynamic personas
- dynamic module subset selection
- visible party discussion
- governance gate
- final synthesis
- namespaced mode markers for `:more` and `:max`

## 2. Install verification

### Remote one-command install

Run:

```bash
curl -fsSL https://raw.githubusercontent.com/Ima8/khon-party/main/install-remote.sh | bash
```

Expected result:

- the base runtime file is downloaded from GitHub
- the verifier is downloaded from GitHub
- the generated marketplace/plugin bundle is downloaded from GitHub
- the downloaded base runtime is validated before install
- `~/.claude/commands/khon-party.md` exists
- the installed base command is validated again
- the `khon-party` marketplace is configured
- the user-scope plugin `khon-party@khon-party` is installed and enabled
- the script prints `/khon-party`, `/khon-party:more`, and `/khon-party:max` as ready-to-use commands

### Source install

Run:

```bash
./install.sh
./verify-install.sh
```

Expected result:

- `~/.claude/commands/khon-party.md` exists
- required sections are present
- the `khon-party` marketplace is configured
- the user-scope plugin `khon-party@khon-party` is installed and enabled
- plugin source files are generated in-repo
- namespaced mode markers are present in `plugins/khon-party/skills/more/SKILL.md` and `plugins/khon-party/skills/max/SKILL.md`
- examples are printed after verification

## 3. Registration checks in Claude Code

Before behavioral testing, confirm the commands are actually discoverable.

### Check 0: base command discovery

After restarting Claude Code:

```text
/skills
```

Or type `/` and confirm `/khon-party` appears in the picker.

### Check 1: namespaced plugin discovery

After restart or after `/reload-plugins`, confirm these appear in the picker:

```text
/khon-party:more
/khon-party:max
```

Notes:
- custom commands are best verified through `/skills` or slash autocomplete
- if `/khon-party` is missing, inspect the installed file frontmatter first
- if `/khon-party:more` or `/khon-party:max` are missing, check `claude plugin list --json`, `claude plugin marketplace list --json`, then inspect the generated plugin files
- for unpublished local changes, `claude --plugin-dir /path/to/khon-party/plugins/khon-party` is still useful as a development-only shortcut
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
- shows a visible party discussion with short reactive turns
- returns a friendlier synthesis

### Case 3: no arguments

```text
/khon-party
```

Check that it:
- uses recent conversation context
- does not start with a setup wizard
- asks a clarifying question only if blocked

### Case 4: broader namespaced mode

```text
/khon-party:more เปรียบเทียบ 3 ทางเลือกนี้
```

Check that it:
- visibly broadens idea harvest versus the default mode
- increases debate pressure without collapsing into max-mode saturation

### Case 5: strongest namespaced mode

```text
/khon-party:max เปรียบเทียบ 3 ทางเลือกนี้
```

Check that it:
- reflects the strongest mode profile
- shows evidence of all-21-module saturation across the reasoning flow
- can expand the visible room when useful
- can run much longer than the base mode when the topic supports it

### Case 6: forced modules

```text
/khon-party:more [modules=cog.role_playing,cog.six_thinking_hats,cog.black_swan] วิเคราะห์โจทย์นี้
```

Check that it:
- respects the explicit module override for the visible debate set
- still applies governance before the final recommendation

### Case 7: risky scenario

Use a prompt with meaningful downside or governance concerns.

Check that it:
- labels recommendations as safe / caution / risky
- reframes risky advice instead of presenting it as unquestioned action

## Pass criteria

- the base command UX remains simple
- namespaced commands are discoverable when the plugin is loaded
- command infers before asking
- output includes debate and synthesis
- governance is visible and separate from synthesis
- advanced controls remain optional
- docs match the actual command-family packaging model
