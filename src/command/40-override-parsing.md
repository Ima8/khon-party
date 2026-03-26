### Part 2: Parse Optional Overrides

Parse optional inline controls from `$ARGUMENTS` when present:

- `[personas=architect,operator,skeptic,governor]`
- `[modules=cog.role_playing,cog.six_thinking_hats]`
- `[depth=light|standard|deep|extended]`
- `[:more]` (back-compat inline token; canonical entrypoint is `/khon-party:more`)
- `[:max]` (back-compat inline token; canonical entrypoint is `/khon-party:max`)
- `[style=debate|panel|adversarial]`
- `[focus=tech|product|biz|ops|research|marketing|governance|innovation]`

Rules:
- Treat explicit `personas=` and `modules=` as overrides.
- If explicit `personas=` is present, use that roster as the visible panel instead of silently restoring balance-first defaults.
- If explicit `modules=` is present, preserve the mandatory brainstorm baseline but let the override define the visible debate modules instead of silently padding the debate set.
- Treat `style=` and `focus=` as strong hints only when that layer is not already explicitly overridden.
- If the user gives no `focus=`, `personas=`, or `modules=`, stay in balance-first default mode and explicitly surface all 7 required angles in the output.
- If the user gives `focus=` without explicit `personas=` or `modules=`, narrow from the balanced default instead of replacing it with a brittle fixed pack.
- `focus=innovation` means bias toward novelty that still creates value and can realistically ship: normally keep `innovator` visible while preserving business/value, market/customer, research/method, execution/system, challenge, and governance pressure rather than novelty theater.
- For `focus=innovation`, make the innovation mapping explicit: normally include the `innovator` persona and innovation-oriented modules such as `cog.scamper` plus `cog.making_of` or `cog.role_playing`, then keep reality pressure via `cog.consequences`, `cog.second_order_observation`, and `cog.black_swan` when downside matters.
- Treat `depth=` as a hint for how expanded the closing synthesis should be, not whether the discussion should be deep.
- Treat `/khon-party:more` as the canonical expanded-selective entrypoint. If the base command is used with explicit `:more`, honor it as a back-compat inline token that broadens brainstorm breadth and increases debate-phase cognitive pressure without forcing full module saturation.
- Treat `/khon-party:max` as the canonical strongest entrypoint. If the base command is used with explicit `:max`, honor it as a back-compat inline token that broadens brainstorm breadth, uses all 21 embedded cognitive modules across ideation and debate, expands the visible panel to roughly 8-9 personas when useful, and allows a much longer discussion than the normal deep baseline.
- Brainstorm always runs before debate, even when the user only asks for debate.
- Keep the party discussion itself in deep mode by default, even if the user gives no depth hint.
- Normal behavior: run BMAD-complete brainstorming internally, then present concise idea clusters and harvest before the debate while keeping KHON augmentation selective.
- `:more` behavior: still run BMAD-complete brainstorming first, but expand ideation breadth materially before clustering and harvesting, and increase debate-phase module coverage and room width only when useful, usually ending around 7-8 visible personas.
- `:max` behavior: still run BMAD-complete brainstorming first, but then saturate the reasoning pass with all 21 embedded cognitive modules, widen the visible panel to roughly 8-9 personas when that helps differentiate perspectives, and let the debate run roughly 50-70 turns plus a longer synthesis when real tension remains.
- If the user asks for `light` or `standard`, keep the discussion deep anyway, but make each turn slightly tighter and shorten the closing synthesis.
- If the user asks for `extended`, allow the discussion and synthesis to run longer than the normal deep baseline.
- Infer everything not explicitly provided.
- Do not ask for these options if the user did not provide them.

Set `selection_method` for modules as one of:
- `force_modules`
- `llm-direct`
- `llm-classify`
- `rule-based`
