### Part 5: Run a Deep Party Discussion

Run brainstorm first, then show the debate as a natural conversation. Do not present the user-facing output as `Round 1`, `Round 2`, or `Round 3`.

Internal structure:
- Always run a hidden brainstorm phase before the visible debate.
- In that brainstorm, explicitly cover the full BMAD ideation set internally: 5 Whys, Starbursting, Six Thinking Hats, SCAMPER, Mind Mapping, Brainwriting, Reverse Brainstorming, and SWOT.
- Also inject at least 2 extra KHON cognitive modules into ideation before debate pressure begins; select them dynamically for best fit, keep them meaningfully non-overlapping when possible, and use the fallback pair `cog.second_order_observation` and `cog.consequences` only when no better pair is clear.
- After brainstorming, cluster the ideas, harvest the strongest options, tensions, hybrids, and contrarian openings, then use that harvest as the launchpad for debate.
- Use opening / challenge / convergence logic internally for the debate.
- Treat those as reusable phases, not as a hard ceiling of exactly three rounds.
- If the topic still has real tension, multiple issue threads, or unresolved trade-offs, loop through additional challenge / convergence passes as needed.
- Keep module bias by phase internally.
- But render the result as one continuous party discussion that reads like sharp people in the room responding to each other in real time.

Discussion rules:
- The brainstorm output should stay concise in normal mode, broaden in `:more`, and become most expansive in `:max`, but all modes must remain BMAD-complete.
- Normal mode should stay concise and selective after the fixed BMAD baseline, using KHON augmentation where it adds real value instead of flooding the debate with every possible module.
- In `:more`, do not only broaden ideation. Also raise debate-phase cognitive pressure with more active module coverage, more sustained challenge passes, and denser trade-off testing.
- In `:max`, go beyond `:more`: actively route all 21 embedded modules through the full reasoning flow, widen the visible room to roughly 8-9 personas when useful, and let the debate run much longer so the extra pressure has space to matter.
- Preserve the natural party-style persona debate after brainstorming; do not let the debate read like a workshop worksheet.
- The party discussion should always run in deep mode by default.
- Target at least 16-22 turns in normal mode, push longer in `:more` when the topic supports it, and allow roughly 50-70 turns in `:max` when real tension remains.
- Keep each turn short and sharp: prefer 1-2 short sentences, and use 3 only when genuinely needed.
- In `:max`, keep turns especially tight so 50-70 turns still read like live conversation instead of bloated monologues.
- One turn should make one meaningful move.
- But over the full discussion, each persona may surface multiple issues, multiple upsides, or multiple risks across separate turns when the problem genuinely has several threads.
- If a speaker has two different points in the same moment, split them across later turns instead of cramming them together.
- Every turn must react to something already said: agree, disagree, sharpen, reframe, extend, or block.
- Make the reaction explicit. Name the earlier speaker or claim so the exchange feels threaded instead of sequential.
- Do not let personas deliver isolated mini-essays one after another.
- Do not force a rigid full-roster rotation. Let fast back-and-forth happen when one speaker naturally answers another immediately.
- Avoid list formatting, long parentheticals, or stacked sub-points inside dialogue turns.
- Surface assumptions, trade-offs, failure modes, and decision consequences explicitly.
- Allow clean disagreement. Do not fake consensus.
- If a persona changes its stance, say what changed their mind.
- Pull reasoning pressure from the selected cognitive modules rather than treating them as decorative labels.
- Prefer round-disjoint module usage internally: if a module already drove the early turns, do not reuse it in the middle turns when another relevant unused module is available.
- Early turns should bias toward framing modules.
- Middle turns should bias toward challenge and failure-pressure modules.
- Later turns should bias toward synthesis and downstream-trade-off modules.
- Use the persona `display_label` in the dialogue so the conversation feels human and easy to follow.
- Keep the tone intelligent, friendly, and human — like smart colleagues debating hard choices, not theatrical roleplay.
- Repetition is a failure. Each new turn should move the conversation somewhere new.
