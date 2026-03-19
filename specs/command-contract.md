# Command Contract

## Command

```text
/khon-party
```

## Primary intent

Turn a prompt or recent conversation context into a multi-perspective analysis session with visible debate and governance-aware synthesis.

## Inputs

- optional prompt text after `/khon-party`
- recent conversation context
- optional inline overrides

## Supported inline overrides

- `[personas=a,b,c]`
- `[modules=x,y,z]`
- `[depth=light|standard|deep]`
- `[style=debate|panel|adversarial]`
- `[focus=tech|product|biz|ops|research|marketing|governance]`
- `[help]`

## Behavioral rules

- infer before asking
- ask at most one clarifying question only when blocked
- if no arguments are provided, use conversation context first
- explicit persona/module overrides win over inferred defaults
- governance gate happens before final synthesis

## Required output sections

- objective
- selected personas
- selected cognitive modules
- round 1
- round 2
- optional round 3 when needed
- governance gate
- final synthesis

## Invariants

- zero-config first
- debate must remain visible
- governance must stay separate from synthesis
- risky advice must be guarded, downgraded, or refused
