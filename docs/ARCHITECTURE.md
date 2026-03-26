# ARCHITECTURE

This is the maintainer brief for `khon-party`.

If you are coming back later to maintain, extend, or debug this repo, read this file first. It explains the product model, prompt architecture, runtime boundary, packaging model, and the rules that should not be broken.

## 1. What khon-party is

`khon-party` is a **Claude Code command family** designed to turn one prompt into a **brainstorm-then-debate** flow.

Its job is not to produce hidden internal reasoning. Its job is to give the user a better visible working session inside Claude Code:
- broaden the idea space first
- pressure-test the strongest options second
- land on a practical recommendation last

The command family is intentionally narrow in scope:
- `/khon-party` — balanced default
- `/khon-party:more` — broader ideation and stronger debate pressure
- `/khon-party:max` — strongest mode with the fullest runtime profile
- zero-config default UX
- visible multi-perspective discussion
- governance-aware synthesis

It is **not**:
- an npm package
- an IDE extension marketplace package
- a setup-heavy command suite that requires first-run configuration
- a hidden chain-of-thought dump

## 2. Product principles

These are the core rules of the project.

1. **Simple default path**
   - The normal user path should stay simple:
     1. install once
     2. restart Claude Code
     3. use `/khon-party`

2. **Namespaced expansion commands**
   - When the plugin is loaded, the preferred expansion syntax is:
     - `/khon-party:more`
     - `/khon-party:max`
   - Inline `[:more]` and `[:max]` on the base command remain only for back-compat.

3. **Zero-config by default**
   - Do not force setup questions, config files, or wizard flows in the normal path.
   - Infer from arguments and conversation context first.

4. **Brainstorm first, debate second**
   - The command should widen the space before converging.
   - It should not jump straight into a narrow answer.

5. **Balance-first defaults**
   - In zero-config mode, the visible output should cover the six required angles:
     - business/value
     - market/customer
     - research/uncertainty
     - execution/system
     - governance/risk
     - challenge/skeptic

6. **Language follows the user**
   - The prompt framework may stay in English internally.
   - The final output should follow the user's prompt language.

7. **Governance before recommendation**
   - Risk must be surfaced before the closing recommendation.
   - Risky advice should be reframed with guardrails, not delivered blindly.

8. **Do not expose internal reasoning artifacts unless they are user-useful**
   - Example: the visible `Thinking Lenses Used` section was intentionally removed.
   - Keep the output human, useful, and selective.

## 3. Runtime architecture

The runtime boundary is intentionally simple, but it now has multiple generated entrypoints that share one core.

### Generated runtime family

The build produces:

```text
khon-v1/commands/khon-party.md
plugins/khon-party/skills/more/SKILL.md
plugins/khon-party/skills/max/SKILL.md
```

### Runtime destinations

- Base command install target:

```text
~/.claude/commands/khon-party.md
```

- Namespaced plugin entrypoints are installed through Claude Code's marketplace/plugin flow in user scope.
- For unpublished local changes, maintainers can still load the plugin directly with `--plugin-dir` during development.

### Source-of-truth authoring model

The runtime family is generated from smaller source files under `src/`.

Key areas:
- `src/command/` — command rules and orchestration instructions
- `src/prompts/personas/` — persona cards
- `src/prompts/modules/` — embedded KHON module cards
- `src/prompts/templates/` — brainstorm / debate / governance / synthesis templates
- `scripts/build_runtime.py` — generator that assembles the runtime family

### Why this split exists

This structure keeps both goals true:
- **users** get a simple base install and clear namespaced expansion entrypoints
- **maintainers** can edit a modular prompt system instead of one giant markdown blob
- **the runtime** stays drift-resistant because every entrypoint is generated from the same shared source tree

## 4. Prompt architecture

At a high level, `khon-party` runs like this:

1. **Objective inference**
   - Read `$ARGUMENTS` first.
   - If arguments are missing or thin, infer the objective from recent conversation context.

2. **Override parsing**
   - Support optional advanced overrides such as:
     - `personas=`
     - `modules=`
     - `depth=`
     - `style=`
     - `focus=`
     - back-compat inline `:more`
     - back-compat inline `:max`

3. **Mode selection**
   - `/khon-party` runs the balanced default profile.
   - `/khon-party:more` behaves as fixed `:more` before any other parsing.
   - `/khon-party:max` behaves as fixed `:max` before any other parsing.

4. **Persona selection**
   - In zero-config mode, start from the balance-first six-angle coverage.
   - If explicit personas are provided, use them as the visible override.

5. **Module selection**
   - Use the embedded module set dynamically.
   - Preserve brainstorm breadth first, then debate pressure.
   - If explicit modules are provided, treat them as the visible override.
   - In max mode, use the full embedded 21-module set across the reasoning flow.

6. **Brainstorm phase**
   - This happens before debate.
   - The output should show the concise outcomes of brainstorming, not a raw worksheet dump.

7. **Debate phase**
   - Visible discussion between selected voices.
   - Turns should be short, sharp, and responsive.
   - The discussion should feel like colleagues actually testing ideas, not formal numbered rounds.

8. **Governance / risk check**
   - Keep governance visibly separate from the closing synthesis.
   - It should be human-readable, not a compliance spreadsheet.

9. **Final synthesis**
   - Close with a friendlier landing point.
   - Recommendation should be plain-language and decision-useful.

## 5. Output contract

The final output should remain structured, but it should feel human rather than framework-heavy.

### Required visible sections

The current visible shape is:
- problem summary
- voices in the room
- emerging threads
- ideas worth carrying forward
- debate
- quick recap
- risk check
- what we landed on
  - shared ground
  - open disagreements
  - recommendation
  - rationale
  - open questions
  - next steps

### Current important output rules

These are deliberate and should not be casually reversed:

- **Do not show `Thinking Lenses Used` in the user-facing output**
- **`Recommendation` must appear before `Next Steps`**
- **`Risk Check` should be normal bullet points, not a table**
- **Do not print visible `Round 1 / Round 2 / Round 3` labels**
- **The closing synthesis should be warmer and clearer than the debate itself**
- **The block after Debate must be copy-ready enough to stand on its own when pasted elsewhere**

### Tone rules

- The discussion can be sharp.
- The synthesis should be calmer, friendlier, and clearer.
- Thai output should read naturally in Thai.
- English output should read naturally in English.
- Avoid exposing internal prompt mechanics unless the user explicitly wants that level of detail.

## 6. Key file map

Use this map when you need to change behavior.

### Core command behavior
- `src/command/00-frontmatter.md`
- `src/command/10-role-and-overview.md`
- `src/command/20-preflight.md`
- `src/command/30-objective-inference.md`
- `src/command/40-override-parsing.md`
- `src/command/50-persona-selection.md`
- `src/command/60-module-selection.md`
- `src/command/70-debate-process.md`
- `src/command/80-governance-gate.md`
- `src/command/90-final-synthesis.md`
- `src/command/95-output-contract.md`
- `src/command/99-llm-notes.md`

### Persona library
- `src/prompts/personas/`

### Module library
- `src/prompts/modules/`

### Reusable templates
- `src/prompts/templates/`

### Generated runtime family
- `khon-v1/commands/khon-party.md`
- `plugins/khon-party/skills/more/SKILL.md`
- `plugins/khon-party/skills/max/SKILL.md`

### Plugin metadata
- `.claude-plugin/marketplace.json`
- `plugins/khon-party/.claude-plugin/plugin.json`

### Install / verify scripts
- `install.sh` — local/source install for the full command family using a local marketplace source
- `install-remote.sh` — one-command remote install for the full command family using downloaded marketplace/plugin files
- `verify-install.sh` — install integrity checks for the installed base command, installed plugin state, and generated plugin source
- `uninstall.sh` — uninstall + restore backup for the full command family

### Public-facing docs
- `README.md`
- `docs/INSTALL.md`
- `docs/VERIFICATION.md`
- `docs/EXAMPLES.md`

## 7. Install and release model

There are two supported install paths plus one local plugin development path.

### A. Remote install (recommended for normal users)

This is the public one-command path:

```bash
curl -fsSL https://raw.githubusercontent.com/Ima8/khon-party/main/install-remote.sh | bash
```

This path:
- downloads the prebuilt base runtime from GitHub
- downloads the verifier
- downloads the generated marketplace/plugin bundle from GitHub
- validates the downloaded base command before install
- installs it into `~/.claude/commands/khon-party.md`
- registers the downloaded marketplace in user scope
- installs `khon-party@khon-party` in user scope
- validates the installed base command, installed marketplace/plugin state, and downloaded plugin bundle
- leaves `/khon-party`, `/khon-party:more`, and `/khon-party:max` ready after restart or `/reload-plugins`

This path should remain simple and not require `python3`.

### B. Source install (for contributors)

This path is for editing the source and rebuilding locally:

```bash
./install.sh
```

This path:
- runs `python3 scripts/build_runtime.py`
- generates the full runtime family
- installs the base command locally
- registers the checkout as a local marketplace source
- installs `khon-party@khon-party` in user scope
- runs `./verify-install.sh`

### C. Local plugin loading path

For unpublished local changes, development and local testing can still use:

```bash
claude --plugin-dir /path/to/khon-party/plugins/khon-party
```

Do not instruct people to write into Claude plugin cache directories directly.

### Release logic

The public generated artifacts are the base command plus plugin metadata and namespaced skills in the repo.

If you change behavior in `src/`, you must rebuild before release.

## 8. Guardrails for future development

These are the easiest ways to accidentally damage the project.

1. **Do not overcomplicate the UX**
   - Do not add setup flows or force the user through configuration.

2. **Do not leak too much internal machinery into the output**
   - Keep output user-useful, not self-referential.

3. **Do not turn the README into internal architecture notes**
   - `README.md` is public/product-facing.
   - This file is the dev-facing overview.

4. **Do not forget balance-first behavior in zero-config mode**
   - Narrowing is allowed when the user explicitly asks for it.
   - Default mode should still widen first.

5. **Do not skip rebuilds after prompt changes**
   - Changes under `src/` do nothing until the runtime family is rebuilt.

6. **Do not forget install verification**
   - After install or release changes, run verification again.

7. **Do not forget commit identity requirements**
   - Use:
     - `Issaret Prachitmutita`
     - `imac.monochrome@gmail.com`
   - Do not leave Claude as author/co-author in git history for this repo.

## 9. Change checklist

When you modify behavior, follow this checklist.

### If you change prompt logic or output behavior
1. edit files in `src/`
2. rebuild with `python3 scripts/build_runtime.py`
3. reinstall locally with `./install.sh`
4. run `./verify-install.sh`
5. smoke test `/khon-party`
6. run `/reload-plugins` or restart Claude Code, then smoke test `/khon-party:more` and `/khon-party:max`
7. if testing unpublished local changes, `claude --plugin-dir ...` is still a useful shortcut
8. review the visible output shape

### If you change install flow or packaging
1. test `install.sh`
2. test `install-remote.sh`
3. re-run `./verify-install.sh`
4. confirm `claude plugin marketplace list --json` and `claude plugin list --json` show the expected installed state
5. if testing unpublished local changes, optionally test `claude --plugin-dir ...`
6. update `README.md` and install docs if needed

### If you change public-facing messaging
1. update `README.md`
2. check that examples still match real behavior
3. make sure public docs do not drift from actual install/release flow

### Before publishing
1. confirm generated runtime family is up to date
2. confirm docs are consistent
3. confirm install scripts work
4. confirm no secrets or local-only references leaked into the repo
5. confirm commit authors are correct

## 10. Related docs

Use these when you need detail beyond this file:
- `README.md` — public-facing project page
- `docs/INSTALL.md` — install paths
- `docs/VERIFICATION.md` — verification checklist
- `docs/EXAMPLES.md` — usage examples
