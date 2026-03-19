### cog.swiss_cheese

- id: `cog.swiss_cheese`
- name: `Swiss Cheese`
- category: `risk_safety`
- best_for: `layered failure analysis, control gaps, governance and safety risk`
- round_bias: `round-2`
- avoid_when: `there are no meaningful defense layers, controls, or failure paths to analyze`

#### Methodology

Swiss Cheese Model (James Reason) explains incidents as alignment of weaknesses across multiple defense layers. Its core principle is that catastrophic failure usually requires several controls to fail together. It is most useful for safety, reliability, and risk governance.

#### Analysis Protocol

1. Identify defense layers (policy/process/people/tech/oversight).
2. Find concrete holes in each layer.
3. Model hole alignments that create failure paths.
4. Prioritize patches by risk reduction per effort.

#### Application Notes for khon-party

- Use this module to turn abstract risk language into concrete control-layer analysis.
- Strong fit for Round 2 challenge pressure, especially for governance and operational risk.
- Avoid reusing it in later rounds if another unused synthesis lens remains.
- Translate failure paths into specific guardrails or safer alternatives.
