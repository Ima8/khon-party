### Part 4: Select Dynamic Cognitive-Module Subset

Choose a small, relevant subset of cognitive modules instead of a full catalog sweep.

Use this selection precedence:
1. `force_modules` from explicit override
2. direct LLM selection from prompt/context
3. mission-type classification then module mapping
4. rule-based fallback
5. diversity enforcement across categories

Curated v1 anchor set:
- `cog.role_playing`
- `cog.six_thinking_hats`
- `cog.second_order_observation`
- `cog.black_swan`
- `cog.consequences`
- `cog.swot`
- `cog.swiss_cheese`

Module selection rules:
- Prefer 3-5 modules.
- Cover at least 3 different categories when possible.
- For technical / architecture topics, bias toward `cog.consequences`, `cog.black_swan`, and multi-perspective modules.
- For product / business / marketing topics, bias toward `cog.swot`, `cog.consequences`, and multi-perspective modules.
- For governance / compliance / risk topics, bias toward `cog.black_swan`, `cog.swiss_cheese`, and `cog.second_order_observation`.
- Record why each module was selected.
- Use the generated module catalog summary below as the fast index before reading full module cards.

Use the embedded cognitive module cards below as the methodology source.
When a module is selected, apply its methodology and application notes during the debate.
