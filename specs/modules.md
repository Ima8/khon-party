# Modules

## v1 objective

Use a curated subset of KHON cognitive modules so the command stays practical and readable.

## Selection precedence

1. explicit `modules=` override
2. direct LLM-driven module choice from prompt/context
3. mission-type classification then module mapping
4. rule-based fallback
5. diversity enforcement

## Curated v1 anchor set

- `cog.role_playing`
- `cog.six_thinking_hats`
- `cog.second_order_observation`
- `cog.black_swan`
- `cog.consequences`
- `cog.swot`
- `cog.swiss_cheese`

## Selection rules

- prefer 3-5 modules
- cover at least 3 categories when possible
- bias module choice according to the actual prompt domain
- record why each module was selected

## Round usage rule

Prefer non-overlapping module usage across rounds when enough relevant modules are available.

- Round 1: framing / perspective modules
- Round 2: challenge / failure-pressure modules
- Round 3: convergence / synthesis modules

If the user forced a very small module set, reuse is allowed when necessary.

## Module source model

Each module file in `src/prompts/modules/` now keeps only the parts relevant to `khon-party`:

- id
- name
- category
- best_for
- round_bias
- avoid_when
- methodology
- analysis protocol
- application notes

## Anti-patterns

Avoid:

- always using the same fixed set
- selecting too many modules for simple prompts
- using advanced controls as required setup
- reusing the same module every round when better unused options exist
