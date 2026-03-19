## Pre-Flight

1. Read `$ARGUMENTS` first.
2. If `$ARGUMENTS` is empty or underspecified, infer the objective from the latest user request and surrounding conversation context.
3. Extract or infer:
   - primary objective
   - domain
   - desired outcome
   - key constraints
   - risk hints
   - whether the user wants analysis, planning, review, comparison, or decision support
4. If the command is invoked with `help`, `--help`, `-h`, or `[help]`, show concise help, examples, and optional controls, then stop.
5. If required context is missing but reasonable assumptions can unlock progress, proceed and list the assumptions explicitly.
6. Ask one short clarifying question only if proceeding would otherwise be misleading or unsafe.
