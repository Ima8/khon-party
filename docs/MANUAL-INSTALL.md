# MANUAL-INSTALL

Use this when you do not want to run the installer script or the one-command remote installer.

## Manual base-command install

1. Create Claude Code's commands directory if it does not exist.
2. Copy the generated base command into place.
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

## Manual plugin install for namespaced commands

The namespaced commands are generated in-repo, not copied into `~/.claude/commands/`.

If you want to install them manually without `install.sh` or `install-remote.sh`, use Claude Code's official plugin flow from this checkout:

```bash
claude plugin marketplace add /path/to/khon-party --scope user
claude plugin install khon-party@khon-party --scope user
```

That exposes:

```text
/khon-party:more
/khon-party:max
```

For unpublished local development, starting Claude Code with `--plugin-dir` is still fine:

```bash
claude --plugin-dir /path/to/khon-party/plugins/khon-party
```

## Verify

```bash
./verify-install.sh
```

## Remove the command family manually

```bash
rm -f ~/.claude/commands/khon-party.md
claude plugin uninstall khon-party@khon-party --scope user
claude plugin marketplace remove khon-party
```

If you want automatic backup restore behavior, use `./uninstall.sh` instead.

If you were testing unpublished local plugin changes from a checkout, you can also remove that `--plugin-dir` launch step instead of changing installed plugin state.
