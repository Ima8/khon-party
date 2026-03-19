### Part 2: Parse Optional Overrides

Parse optional inline controls from `$ARGUMENTS` when present:

- `[personas=architect,operator,skeptic,governor]`
- `[modules=cog.role_playing,cog.six_thinking_hats]`
- `[depth=light|standard|deep]`
- `[style=debate|panel|adversarial]`
- `[focus=tech|product|biz|ops|research|marketing|governance]`

Rules:
- Treat explicit `personas=` and `modules=` as overrides.
- Treat `depth=`, `style=`, and `focus=` as strong hints.
- Infer everything not explicitly provided.
- Do not ask for these options if the user did not provide them.

Set `selection_method` for modules as one of:
- `force_modules`
- `llm-direct`
- `llm-classify`
- `rule-based`
