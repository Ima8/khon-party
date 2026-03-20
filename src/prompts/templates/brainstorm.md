### brainstorm

Goal: always run a full brainstorm pass before the visible persona debate.
This phase is internal for reasoning, but its outcomes must be surfaced to the user as localized idea clusters and an idea harvest.

Mandatory internal brainstorm stack:
1. 5 Whys — expose root causes, not just surface symptoms.
2. Starbursting — generate key questions, constraints, unknowns, and demand edges.
3. Six Thinking Hats — force parallel modes across facts, benefits, cautions, feelings, process, and creativity.
4. SCAMPER — mutate, adapt, combine, remove, reverse, and reframe candidate directions.
5. Mind Mapping — spread the problem into adjacent themes, dependencies, and opportunity branches.
6. Brainwriting — generate multiple candidate ideas in parallel before convergence.
7. Reverse Brainstorming — ask how to make the situation worse, fail faster, or create resistance, then invert those findings.
8. SWOT — compare internal strengths and weaknesses against external opportunities and threats.

Mandatory extra KHON ideation modules:
- Apply at least 2 additional KHON modules during ideation itself.
- Treat the BMAD brainstorm set above as a fixed baseline that never changes.
- Select the extra KHON ideation modules dynamically at runtime based on prompt fit.
- Prefer a non-overlapping pair: do not pick two modules that mostly apply the same reasoning move if a broader pair is available.
- Use the fallback pair `cog.second_order_observation` + `cog.consequences` only when no clearly better pair emerges from the prompt/context.
- `cog.second_order_observation`: challenge how different observers frame the same problem and what those frames hide.
- `cog.consequences`: trace first-, second-, and third-order effects while the idea space is still expanding.
- Name which dynamic pair shaped ideation and why that pair was chosen over other available modules.

Mode behavior:
- Normal mode: run the full BMAD + KHON brainstorm stack internally, keep the visible output concise, and use selective KHON augmentation rather than maximal module spread.
- `:max` mode: run the same fixed BMAD baseline, widen the search materially with more divergent branches, more hybrid combinations, more contrarian paths, and broader cluster coverage before debate, then carry that expansion forward into denser debate-phase module coverage and stronger cognitive pressure.

Brainstorm deliverables before debate:
- idea clusters: 2-6 thematic groups that summarize the main directions that emerged.
- idea harvest: strongest options, risky or contrarian bets, hybrid combinations, and fragments worth preserving.
- bridge to debate: identify which harvested ideas deserve immediate persona pressure-testing in the visible discussion.

Do not dump the whole workshop transcript to the user.
Show only the distilled clusters and harvested ideas in the user's language, then transition cleanly into a natural party-style debate.
