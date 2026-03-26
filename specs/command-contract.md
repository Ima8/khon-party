# Command Contract

## Command family

```text
/khon-party
/khon-party:more
/khon-party:max
```

## Primary intent

Turn a prompt or recent conversation context into a multi-perspective analysis session with visible debate and governance-aware synthesis.

## Mode semantics

- `/khon-party` — balanced default
- `/khon-party:more` — broader ideation and stronger debate pressure
- `/khon-party:max` — strongest mode with all 21 modules across the reasoning flow and the longest debate profile

Inline `[:more]` and `[:max]` on `/khon-party` remain supported for back-compat, but the namespaced commands are the preferred expansion syntax once the plugin is loaded.

## Inputs

- optional prompt text after the command invocation
- recent conversation context
- optional inline overrides

## Supported inline overrides

- `[personas=a,b,c]`
- `[modules=x,y,z]`
- `[depth=light|standard|deep|extended]`
- `[style=debate|panel|adversarial]`
- `[focus=tech|product|biz|ops|research|marketing|governance|innovation]`
- `[help]`
- back-compat inline `[:more]`
- back-compat inline `[:max]`

## Behavioral rules

- infer before asking
- ask at most one clarifying question only when blocked
- if no arguments are provided, use conversation context first
- explicit persona/module overrides win over inferred defaults
- governance gate happens before final synthesis
- `/khon-party:more` behaves as fixed `:more` before other parsing
- `/khon-party:max` behaves as fixed `:max` before other parsing

## Required output sections

- problem summary
- voices in the room
- emerging threads
- ideas worth carrying forward
- debate
- quick recap
- governance / risk check
- final synthesis

## Invariants

- zero-config first
- debate must remain visible
- governance must stay separate from synthesis
- risky advice must be guarded, downgraded, or refused
- all entrypoints must be generated from the same shared source tree
