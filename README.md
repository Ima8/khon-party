# khon-party — Think Wider. Debate Sharper.

Turn one Claude Code prompt into a real brainstorm-then-debate session.

`khon-party` helps you widen the idea space first, pressure-test the strongest options, and land on a practical recommendation — inside Claude Code, without a setup wizard or prompt gymnastics.

**What makes it useful:**
- a command family with clear entrypoints: `/khon-party`, `/khon-party:more`, `/khon-party:max`
- visible multi-perspective discussion instead of a single narrow frame
- balance-first default across 6 angles: business, market, research, execution, risk, and skepticism
- Thai or English output that follows the user's prompt language
- governance-aware synthesis with practical next steps

## Command family

Use the entrypoint that matches the amount of pressure you want:

- `/khon-party` — balanced default
- `/khon-party:more` — broader ideation and stronger debate pressure
- `/khon-party:max` — the fullest mode: all 21 modules, a bigger room when useful, and the longest debate scale

Inline `[:more]` and `[:max]` still work on the base command for back-compat. The namespaced commands above are the preferred expansion syntax once the plugin is loaded.

## Install the full command family in one command

Recommended for normal users:

```bash
curl -fsSL https://raw.githubusercontent.com/Ima8/khon-party/main/install-remote.sh | bash
```

That one command installs the full family:
- `/khon-party`
- `/khon-party:more`
- `/khon-party:max`

It does this with Claude Code's official marketplace and plugin install flow:
- installs the base command into `~/.claude/commands/khon-party.md`
- downloads the generated marketplace and plugin bundle
- registers the marketplace in user scope
- installs `khon-party@khon-party` in user scope

Then:
1. restart Claude Code or run `/reload-plugins`
2. type `/khon-party ...`
3. use `/khon-party:more` or `/khon-party:max` when you want more pressure

Examples:

```text
/khon-party Should we launch this product now, and how should we position it?
```

```text
/khon-party:more Help me plan the launch of this feature from a cross-functional angle.
```

```text
/khon-party:max Pressure-test this architecture before we commit.
```

## Development and local testing

The repo also ships the generated plugin metadata directly:

```text
.claude-plugin/marketplace.json
plugins/khon-party/.claude-plugin/plugin.json
```

and the namespaced skills at:

```text
plugins/khon-party/skills/more/SKILL.md
plugins/khon-party/skills/max/SKILL.md
```

So the base command and namespaced variants are all generated from the same shared source tree.

If you are testing unpublished local changes, you can still launch Claude Code directly from the checkout with:

```bash
claude --plugin-dir /path/to/khon-party/plugins/khon-party
```

## What it is good for

Use `khon-party` when one normal prompt feels too narrow.

It works especially well for:
- architecture trade-offs
- product strategy and launch planning
- prioritization and roadmap debates
- cross-functional decisions with many stakeholders
- risky recommendations that need pressure-testing before action

## What you get back

Instead of one flat answer, `khon-party` gives you a more structured outcome:
- a quick framing of the real problem
- a visible panel of voices with different angles
- broader idea generation before the answer collapses too early
- a sharp party-style discussion with trade-offs and disagreement
- a separate risk check
- a friendlier synthesis with practical next steps

## Why people use it

Most prompting collapses into one frame too early.

`khon-party` is designed to avoid that by default:
- **brainstorm first** so the idea space stays broad
- **debate second** so strong options get challenged
- **balance first** so the answer does not lean only toward one viewpoint
- **governance before recommendation** so risky advice gets reframed instead of pushed blindly

## Why it feels different

`khon-party` is not trying to be a giant command suite.

It is intentionally narrow in scope:
- one shared runtime family
- strong defaults
- optional advanced controls
- no first-run configuration
- no need to manually assemble personas or thinking frameworks unless you want to

## Quick examples

Use the balanced default:

```text
/khon-party Review this system from engineering, business, and governance angles
```

Use current conversation context:

```text
/khon-party
```

Use the broader namespaced mode:

```text
/khon-party:more Compare these three options and make the debate wider before landing
```

Use the strongest namespaced mode:

```text
/khon-party:max Pressure-test this architecture with the fullest room and the hardest trade-off scan
```

Force personas if you want tighter control:

```text
/khon-party [personas=architect,operator,skeptic,governor] Review this system as a constrained technical panel
```

Force modules if you want a specific style of pressure:

```text
/khon-party:more [modules=cog.role_playing,cog.six_thinking_hats,cog.black_swan] Compare these three options and stress-test the downside
```

See [`docs/EXAMPLES.md`](docs/EXAMPLES.md) for more.

## How it works

`khon-party` will:
1. infer the real objective from your prompt and recent context
2. widen the idea space before locking into one recommendation
3. assemble a balance-first panel by default across business/value, market/customer, research/uncertainty, execution/system, governance/risk, and challenge/skeptic
4. choose a dynamic subset from the embedded 21-module KHON prompt pack, or use the stronger mode profiles when you call `:more` or `:max`
5. run a visible party-style discussion with short, reactive turns
6. apply a governance gate before the final recommendation
7. return a practical synthesis with next steps

## Requirements

For the recommended remote install path:
- Claude Code installed and working
- macOS, Linux, or WSL with `bash`
- `curl` or `wget`
- permission to write to `~/.claude/commands/`
- permission to let Claude Code register a marketplace and install a user-scope plugin

For local/source install:
- everything above
- `python3`

This is a Claude Code custom command + plugin namespace project, not an npm package or an IDE marketplace extension.

## Install from source

Use this if you want to edit the source, rebuild the runtime, or contribute to the repo.

```bash
git clone https://github.com/Ima8/khon-party.git
cd khon-party
chmod +x install.sh verify-install.sh uninstall.sh install-remote.sh
./install.sh
```

What `install.sh` does:
1. builds the generated command family from `src/`
2. installs the base command to `~/.claude/commands/khon-party.md`
3. backs up an older installed base command if one already exists
4. registers this checkout as a local Claude marketplace source
5. installs `khon-party@khon-party` in user scope
6. runs `./verify-install.sh`

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
/khon-party:more Compare these options with a broader room
/khon-party:max Should we take this high-stakes bet now?
```

If the base command does not appear:
1. restart Claude Code again
2. check that `~/.claude/commands/khon-party.md` exists
3. rerun `./verify-install.sh`
4. make sure the installed file still has valid YAML frontmatter

If the namespaced commands do not appear:
1. run `/reload-plugins` or restart Claude Code
2. run `claude plugin list --json` and confirm `khon-party@khon-party` is installed and enabled
3. run `claude plugin marketplace list --json` and confirm the `khon-party` marketplace is configured
4. check `plugins/khon-party/.claude-plugin/plugin.json`
5. check `plugins/khon-party/skills/more/SKILL.md`
6. check `plugins/khon-party/skills/max/SKILL.md`
7. if testing unpublished local changes, relaunch with `claude --plugin-dir /path/to/khon-party/plugins/khon-party`

To uninstall the command family:

```bash
./uninstall.sh
```

## Advanced usage

Advanced controls are optional and intentionally hidden from the default flow.

Examples:

```text
/khon-party [personas=architect,operator,skeptic,governor] Review this architecture with a constrained panel
/khon-party [modules=cog.role_playing,cog.six_thinking_hats] [depth=deep] Analyze this problem deeply
/khon-party:more [style=debate] Compare these three options
/khon-party:max [focus=innovation] Find a differentiated direction that could still ship
```

## Project structure

```text
khon-party/
├── src/                                   # editable source fragments
├── scripts/                               # runtime build script
├── khon-v1/commands/khon-party.md         # generated base command
├── .claude-plugin/marketplace.json        # marketplace metadata for plugin distribution
├── plugins/khon-party/
│   ├── .claude-plugin/plugin.json         # plugin namespace metadata
│   └── skills/
│       ├── more/SKILL.md                  # /khon-party:more
│       └── max/SKILL.md                   # /khon-party:max
├── install.sh                             # local/source install
├── install-remote.sh                      # one-command full-family install
├── uninstall.sh
├── verify-install.sh
├── docs/
├── examples/
├── prompts/
├── skills/
└── specs/
```

## For contributors

The generated runtime family is built from shared source:

```text
khon-v1/commands/khon-party.md
plugins/khon-party/skills/more/SKILL.md
plugins/khon-party/skills/max/SKILL.md
```

The editable source lives under `src/`, including:
- `src/command/` for command fragments
- `src/prompts/personas/` for persona cards
- `src/prompts/modules/` for the embedded KHON cognitive module cards
- `src/prompts/templates/` for brainstorm, debate, governance, and synthesis templates

To regenerate the runtime family locally:

```bash
python3 scripts/build_runtime.py
```

## Design principles

- zero-config first
- brainstorm first, debate second
- visible discussion before synthesis
- balance-first defaults
- governance before risky advice
- namespaced expansion commands when the plugin is loaded
- advanced options available without cluttering the main path

## License

This project is licensed under **CC BY-NC-SA 4.0**.

That means people can fork and adapt it, but they must:
- give credit
- keep it non-commercial
- share derivatives under the same license

See [`LICENSE`](LICENSE) for the full text.

The scope here is intentionally narrow: one strong command family, one simple install path, and one shared runtime model behind every entrypoint.
