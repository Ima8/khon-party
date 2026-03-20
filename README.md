# khon-party — Think Wider. Debate Sharper.

Turn one Claude Code prompt into a real brainstorm-then-debate session.

`/khon-party` helps you widen the idea space first, pressure-test the strongest options, and land on a practical recommendation — inside Claude Code, with no setup wizard and no prompt gymnastics.

**What makes it useful:**
- one command, no config
- visible multi-perspective discussion instead of a single narrow frame
- balance-first default across 6 angles: business, market, research, execution, risk, and skepticism
- Thai or English output that follows the user's prompt language
- governance-aware synthesis with practical next steps

## Install in one command

Recommended for normal users:

```bash
curl -fsSL https://raw.githubusercontent.com/Ima8/khon-party/main/install-remote.sh | bash
```

Then:
1. restart Claude Code
2. type `/khon-party ...`
3. start using it immediately

Example:

```text
/khon-party Should we launch this product now, and how should we position it?
```

```text
/khon-party Help me plan the launch of this feature from a cross-functional angle.
```

## What it is good for

Use `/khon-party` when one normal prompt feels too narrow.

It works especially well for:
- architecture trade-offs
- product strategy and launch planning
- prioritization and roadmap debates
- cross-functional decisions with many stakeholders
- risky recommendations that need pressure-testing before action

## What you get back

Instead of one flat answer, `/khon-party` gives you a more structured outcome:
- a quick framing of the real problem
- a visible panel of voices with different angles
- broader idea generation before the answer collapses too early
- a sharp party-style discussion with trade-offs and disagreement
- a separate risk check
- a friendlier synthesis with practical next steps

## Why people use it

Most prompting collapses into one frame too early.

`/khon-party` is designed to avoid that by default:
- **brainstorm first** so the idea space stays broad
- **debate second** so strong options get challenged
- **balance first** so the answer does not lean only toward one viewpoint
- **governance before recommendation** so risky advice gets reframed instead of pushed blindly

## Why it feels different

`khon-party` is not trying to be a big command suite.

It is intentionally narrow in scope:
- one command
- strong defaults
- optional advanced controls
- no first-run configuration
- no need to manually assemble personas or thinking frameworks unless you want to

## Quick examples

Use it with a direct prompt:

```text
/khon-party Review this system from engineering, business, and governance angles
```

Use it with the current conversation context:

```text
/khon-party
```

Force personas if you want tighter control:

```text
/khon-party [personas=architect,operator,skeptic,governor] Review this system as a constrained technical panel
```

Force modules if you want a specific style of pressure:

```text
/khon-party [modules=cog.role_playing,cog.six_thinking_hats,cog.black_swan] Compare these three options and stress-test the downside
```

See [`docs/EXAMPLES.md`](docs/EXAMPLES.md) for more.

## How it works

`/khon-party` will:
1. infer the real objective from your prompt and recent context
2. widen the idea space before locking into one recommendation
3. assemble a balance-first panel by default across business/value, market/customer, research/uncertainty, execution/system, governance/risk, and challenge/skeptic
4. choose a dynamic subset from the embedded 21-module KHON prompt pack
5. run a visible party-style discussion with short, reactive turns
6. apply a governance gate before the final recommendation
7. return a practical synthesis with next steps

## Requirements

For the recommended remote install path:
- Claude Code installed and working
- macOS, Linux, or WSL with `bash`
- `curl` or `wget`
- permission to write to `~/.claude/commands/`

For local/source install:
- everything above
- `python3`

This is a Claude Code custom command, not an npm package or an IDE marketplace extension.

## Install from source

Use this if you want to edit the source, rebuild the runtime, or contribute to the repo.

```bash
git clone https://github.com/Ima8/khon-party.git
cd khon-party
chmod +x install.sh verify-install.sh uninstall.sh install-remote.sh
./install.sh
```

What `install.sh` does:
1. builds the generated runtime from `src/`
2. copies the final command to `~/.claude/commands/khon-party.md`
3. backs up an older installed `khon-party` command if one already exists
4. runs `./verify-install.sh`

## Verification and troubleshooting

After a one-command remote install, verification is already run automatically.

After a source install, you can run:

```bash
./verify-install.sh
```

Then restart Claude Code and try:

```text
/khon-party help
/khon-party Review this plan from a cross-functional perspective
/khon-party Should we enter this market now?
```

If the command does not appear:
1. restart Claude Code again
2. check that `~/.claude/commands/khon-party.md` exists
3. if you used source install, rerun `./verify-install.sh`
4. make sure the installed file still has valid YAML frontmatter

To remove the command:

```bash
./uninstall.sh
```

## Advanced usage

Advanced controls are optional and intentionally hidden from the default flow.

Examples:

```text
/khon-party [personas=architect,operator,skeptic,governor] Review this architecture with a constrained panel
/khon-party [modules=cog.role_playing,cog.six_thinking_hats] [depth=deep] Analyze this problem deeply
/khon-party [style=debate] Compare these three options
/khon-party [focus=innovation] Find a differentiated direction that could still ship
```

## Project structure

```text
khon-party/
├── src/                         # editable source fragments
├── scripts/                     # runtime build script
├── khon-v1/commands/khon-party.md
├── install.sh                   # local/source install
├── install-remote.sh            # one-command remote install
├── uninstall.sh
├── verify-install.sh
├── docs/
├── examples/
├── prompts/
├── skills/
└── specs/
```

## For contributors

The installed runtime is a single self-contained file:

```text
khon-v1/commands/khon-party.md
```

But the editable source lives under `src/`, including:
- `src/command/` for command fragments
- `src/prompts/personas/` for persona cards
- `src/prompts/modules/` for the embedded KHON cognitive module cards
- `src/prompts/templates/` for brainstorm, debate, governance, and synthesis templates

To regenerate the runtime locally:

```bash
python3 scripts/build_runtime.py
```

## Design principles

- zero-config first
- brainstorm first, debate second
- visible discussion before synthesis
- balance-first defaults
- governance before risky advice
- advanced options available without cluttering the main path

## License

This project is licensed under **CC BY-NC-SA 4.0**.

That means people can fork and adapt it, but they must:
- give credit
- keep it non-commercial
- share derivatives under the same license

See [`LICENSE`](LICENSE) for the full text.

The scope here is intentionally narrow: one command, one simple install path, and one strong default user experience.
