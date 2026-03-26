# INSTALL

`khon-party` now ships as a command family:

- `/khon-party` — balanced default
- `/khon-party:more` — broader ideation and stronger debate pressure
- `/khon-party:max` — strongest mode with the fullest runtime profile

## Recommended install

Install the full command family without cloning the repo:

```bash
curl -fsSL https://raw.githubusercontent.com/Ima8/khon-party/main/install-remote.sh | bash
```

This one-line flow installs:

```text
/khon-party
/khon-party:more
/khon-party:max
```

It downloads the generated runtime plus the generated marketplace/plugin bundle, then uses Claude Code's official marketplace and plugin install commands to register and install the namespaced commands in user scope.

After install, restart Claude Code or run `/reload-plugins`.

## Source install

If you want to edit or rebuild the command family locally:

```bash
chmod +x install.sh verify-install.sh uninstall.sh install-remote.sh
./install.sh
```

## What gets installed

### Base command install target

The installer copies the base runtime command to:

```text
~/.claude/commands/khon-party.md
```

### Generated plugin source

The build also generates plugin files in the repo:

```text
.claude-plugin/marketplace.json
plugins/khon-party/.claude-plugin/plugin.json
plugins/khon-party/skills/more/SKILL.md
plugins/khon-party/skills/max/SKILL.md
```

The install scripts use those generated files through Claude Code's official marketplace/plugin flow. They do not write directly into Claude plugin cache directories.

## After install

Restart Claude Code, then confirm the base command is discoverable:

```text
/skills
```

Or type `/` and look for `/khon-party` in the picker.

Also look for:

```text
/khon-party:more
/khon-party:max
```

Then try:

```text
/khon-party help
/khon-party วิเคราะห์โจทย์นี้ในมุม dev + biz + governance
/khon-party:more Compare these options with broader debate pressure
/khon-party:max Pressure-test this decision with the fullest mode
```

## Verification

Run:

```bash
./verify-install.sh
```

That checks all of these:
- the installed base command
- the installed marketplace and plugin state
- the generated plugin source files in the repo

See `docs/VERIFICATION.md` for a fuller manual checklist.
