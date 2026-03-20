# INSTALL

`khon-party` is designed for a simple install path.

## Recommended install

Install without cloning the repo:

```bash
curl -fsSL https://raw.githubusercontent.com/Ima8/khon-party/main/install-remote.sh | bash
```

Then restart Claude Code and use `/khon-party`.

## Source install

If you want to edit or rebuild the command locally:

```bash
chmod +x install.sh verify-install.sh uninstall.sh install-remote.sh
./install.sh
```

## Installed file

The installer copies the runtime command to:

```text
~/.claude/commands/khon-party.md
```

## What gets installed

Only the runtime command file is installed for v1.

- Runtime file: `khon-v1/commands/khon-party.md`
- Support files in `docs/`, `prompts/`, `skills/`, and `specs/` are not runtime dependencies.

## After install

Restart Claude Code, then confirm the command is discoverable:

```text
/skills
```

Or type `/` and look for `/khon-party` in the command/skill picker.

Then try:

```text
/khon-party help
/khon-party วิเคราะห์โจทย์นี้ในมุม dev + biz + governance
/khon-party
```

## Verification

Run:

```bash
./verify-install.sh
```

See `docs/VERIFICATION.md` for a fuller manual checklist.
