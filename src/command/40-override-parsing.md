### Part 2: Parse Optional Overrides

Parse optional inline controls from `$ARGUMENTS` when present:

- `[personas=architect,operator,skeptic,governor]`
- `[modules=cog.role_playing,cog.six_thinking_hats]`
- `[depth=light|standard|deep|extended]`
- `[:max]`
- `[style=debate|panel|adversarial]`
- `[focus=tech|product|biz|ops|research|marketing|governance|innovation]`

Rules:
- Treat explicit `personas=` and `modules=` as overrides.
- If explicit `personas=` is present, use that roster as the visible panel instead of silently restoring balance-first defaults.
- If explicit `modules=` is present, preserve the mandatory brainstorm baseline but let the override define the visible debate modules instead of silently padding the debate set.
- Treat `style=` and `focus=` as strong hints only when that layer is not already explicitly overridden.
- If the user gives no `focus=`, `personas=`, or `modules=`, stay in balance-first default mode and explicitly surface all 6 required angles in the output.
- If the user gives `focus=` without explicit `personas=` or `modules=`, narrow from the balanced default instead of replacing it with a brittle fixed pack.
- `focus=innovation` means bias toward novelty that still creates value and can realistically ship: usually favor product/value, market/customer, research/uncertainty, execution/system, skepticism, and governance-aware pressure rather than novelty theater.
- For `focus=innovation`, make the innovation mapping explicit: normally include the `innovator` persona and innovation-oriented modules such as `cog.scamper` plus `cog.making_of` or `cog.role_playing`, then keep reality pressure via `cog.consequences`, `cog.second_order_observation`, and `cog.black_swan` when downside matters.
- Treat `depth=` as a hint for how expanded the closing synthesis should be, not whether the discussion should be deep.
- Treat explicit `:max` as an expansion override for both brainstorm breadth and debate-phase cognitive pressure.
- Brainstorm always runs before debate, even when the user only asks for debate.
- Keep the party discussion itself in deep mode by default, even if the user gives no depth hint.
- Normal behavior: run BMAD-complete brainstorming internally, then present concise idea clusters and harvest before the debate while keeping KHON augmentation selective.
- `:max` behavior: still run BMAD-complete brainstorming first, but expand ideation breadth materially before clustering and harvesting and increase debate-phase module coverage and cognitive pressure afterward.
- If the user asks for `light` or `standard`, keep the discussion deep anyway, but make each turn slightly tighter and shorten the closing synthesis.
- If the user asks for `extended`, allow the discussion and synthesis to run longer than the normal deep baseline.
- Infer everything not explicitly provided.
- Do not ask for these options if the user did not provide them.

Set `selection_method` for modules as one of:
- `force_modules`
- `llm-direct`
- `llm-classify`
- `rule-based`
