# MANUAL-INSTALL

Use this when you do not want to run the installer script.

## Manual steps

1. Create Claude Code's commands directory if it does not exist.
2. Copy the runtime command into place.
3. Restart Claude Code.

```bash
mkdir -p ~/.claude/commands
cp khon-v1/commands/khon-party.md ~/.claude/commands/khon-party.md
chmod 0644 ~/.claude/commands/khon-party.md
```

## Optional backup

If you already have a command at the same path, back it up first:

```bash
mkdir -p ~/.claude/backups/khon-party
cp ~/.claude/commands/khon-party.md ~/.claude/backups/khon-party/khon-party.md.manual.bak
```

## Verify

```bash
./verify-install.sh
```

## Remove manually

```bash
rm -f ~/.claude/commands/khon-party.md
```

If you want automatic backup restore behavior, use `./uninstall.sh` instead.
