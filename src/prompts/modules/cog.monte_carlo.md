### cog.monte_carlo

- id: `cog.monte_carlo`
- name: `Monte Carlo`
- category: `risk_safety`
- best_for: `uncertainty ranges, scenario spread, probabilistic confidence instead of single-point forecasts`
- round_bias: `round-2, round-3`
- avoid_when: `the prompt lacks meaningful variable uncertainty and would only invite fake precision`

#### Methodology

Monte Carlo reasoning explores how outcomes move when uncertain variables vary across many plausible combinations. Its core principle is distribution thinking: a range with probabilities is often more honest than one confident estimate. It is most useful when timing, demand, cost, or risk depends on uncertain inputs.

#### Analysis Protocol

1. Identify the key uncertain variables driving the outcome.
2. Define plausible ranges or scenarios for each variable.
3. Examine best-case, base-case, and downside outcome spread.
4. Recommend choices that remain acceptable across the distribution, not only the optimistic case.

#### Application Notes for khon-party

- Use this module when the debate is leaning too hard on a single forecast or confident number.
- Strong fit for Round 2 challenge pressure and Round 3 decision hardening.
- Pair well with Black Swan for downside resilience or with Pareto for focused mitigation.
- Keep the reasoning qualitative if the prompt lacks real numbers; do not fabricate precision.
