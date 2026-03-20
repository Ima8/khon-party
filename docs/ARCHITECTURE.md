# ARCHITECTURE

This is the single-file developer brief for `khon-party`.

If you are coming back later to maintain, extend, or debug this repo, read this file first. It is meant to explain the product model, prompt architecture, runtime boundary, and the rules that should not be broken.

## 1. What khon-party is

`khon-party` is a **Claude Code custom command** designed to turn one prompt into a **brainstorm-then-debate** flow.

Its job is not to produce hidden internal reasoning. Its job is to give the user a better visible working session inside Claude Code:
- broaden the idea space first
- pressure-test the strongest options second
- land on a practical recommendation last

The command is intentionally narrow in scope:
- one command: `/khon-party`
- zero-config default UX
- visible multi-perspective discussion
- governance-aware synthesis

It is **not**:
- an npm package
- an IDE extension marketplace package
- a multi-command framework that requires setup before first use
- a hidden chain-of-thought dump

## 2. Product principles

These are the core rules of the project.

1. **One-command UX**
   - The normal user path should stay simple:
     1. install once
     2. restart Claude Code
     3. use `/khon-party`

2. **Zero-config by default**
   - Do not force setup questions, config files, or wizard flows in the normal path.
   - Infer from arguments and conversation context first.

3. **Brainstorm first, debate second**
   - The command should widen the space before converging.
   - It should not jump straight into a narrow answer.

4. **Balance-first defaults**
   - In zero-config mode, the visible output should cover the six required angles:
     - business/value
     - market/customer
     - research/uncertainty
     - execution/system
     - governance/risk
     - challenge/skeptic

5. **Language follows the user**
   - The prompt framework may stay in English internally.
   - The final output should follow the user's prompt language.

6. **Governance before recommendation**
   - Risk must be surfaced before the closing recommendation.
   - Risky advice should be reframed with guardrails, not delivered blindly.

7. **Do not expose internal reasoning artifacts unless they are user-useful**
   - Example: the visible `Thinking Lenses Used` section was intentionally removed.
   - Keep the output human, useful, and selective.

## 3. Runtime architecture

The runtime boundary is intentionally simple.

### Installed artifact

The actual installed command is one generated file:

```text
khon-v1/commands/khon-party.md
```

That file is installed to:

```text
~/.claude/commands/khon-party.md
```

The end user should never need the rest of the repo at runtime if they are using the prebuilt install path.

### Source-of-truth authoring model

The runtime is generated from smaller source files under `src/`.

Key areas:
- `src/command/` — command rules and orchestration instructions
- `src/prompts/personas/` — persona cards
- `src/prompts/modules/` — embedded KHON module cards
- `src/prompts/templates/` — brainstorm / debate / governance / synthesis templates
- `scripts/build_runtime.py` — generator that assembles the final runtime file

### Why this split exists

This structure keeps both goals true:
- **users** get a single installable command file
- **maintainers** can edit a modular prompt system instead of one giant markdown blob

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
     - `:max`

3. **Persona selection**
   - In zero-config mode, start from the balance-first six-angle coverage.
   - If explicit personas are provided, use them as the visible override.

4. **Module selection**
   - Use the embedded module set dynamically.
   - Preserve brainstorm breadth first, then debate pressure.
   - If explicit modules are provided, treat them as the visible override.

5. **Brainstorm phase**
   - This happens before debate.
   - The output should show the concise outcomes of brainstorming, not a raw worksheet dump.

6. **Debate phase**
   - Visible discussion between selected voices.
   - Turns should be short, sharp, and responsive.
   - The discussion should feel like colleagues actually testing ideas, not formal numbered rounds.

7. **Governance / risk check**
   - Keep governance visibly separate from the closing synthesis.
   - It should be human-readable, not a compliance spreadsheet.

8. **Final synthesis**
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

### Generated runtime
- `khon-v1/commands/khon-party.md`

### Install / verify scripts
- `install.sh` — local/source install
- `install-remote.sh` — one-command remote install
- `verify-install.sh` — install integrity checks
- `uninstall.sh` — uninstall + restore backup if available

### Public-facing docs
- `README.md`
- `docs/INSTALL.md`
- `docs/VERIFICATION.md`
- `docs/EXAMPLES.md`

## 7. Install and release model

There are two supported install paths.

### A. Remote install (recommended for normal users)

This is the public one-command path:

```bash
curl -fsSL https://raw.githubusercontent.com/Ima8/khon-party/main/install-remote.sh | bash
```

This path:
- downloads the prebuilt runtime from GitHub
- downloads the verifier
- validates the downloaded file
- installs it into `~/.claude/commands/khon-party.md`
- validates the installed file again

This path should remain simple and not require `python3`.

### B. Source install (for contributors)

This path is for editing the source and rebuilding locally:

```bash
./install.sh
```

This path:
- runs `python3 scripts/build_runtime.py`
- generates `khon-v1/commands/khon-party.md`
- installs it locally
- runs `./verify-install.sh`

### Release logic

The public artifact is the generated runtime file in the repo:

```text
khon-v1/commands/khon-party.md
```

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
   - Changes under `src/` do nothing until the runtime is rebuilt.

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
5. smoke test `/khon-party` in Claude Code
6. review the visible output shape

### If you change install flow or packaging
1. test `install.sh`
2. test `install-remote.sh`
3. re-run `./verify-install.sh`
4. update `README.md` and install docs if needed

### If you change public-facing messaging
1. update `README.md`
2. check that examples still match real behavior
3. make sure public docs do not drift from actual install/release flow

### Before publishing
1. confirm generated runtime is up to date
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
