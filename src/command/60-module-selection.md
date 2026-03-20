### Part 4: Select Dynamic Cognitive-Module Subset

Choose cognitive support in two layers: a mandatory brainstorm core first, then a debate-oriented subset.

Use this selection precedence:
1. `force_modules` from explicit override
2. direct LLM selection from prompt/context
3. mission-type classification then module mapping
4. rule-based fallback
5. diversity enforcement across categories

Curated embedded 21-module set:
- Framing and ideation: `cog.starbursting`, `cog.five_whys`, `cog.scamper`, `cog.mind_mapping`, `cog.reverse_brainstorming`, `cog.six_thinking_hats`, `cog.swot`
- Perspectives and people: `cog.role_playing`, `cog.second_order_observation`, `cog.friend_request_trust`, `cog.conflict_resolution`
- Risk and reality pressure: `cog.black_swan`, `cog.swiss_cheese`, `cog.face_it`, `cog.monte_carlo`
- Strategy, prioritization, and execution: `cog.consequences`, `cog.pareto`, `cog.eisenhower`, `cog.making_of`, `cog.double_loop_learning`, `cog.result_optimisation`
- Default behavior must stay simple: auto-select from this curated 21-module set internally and do not ask the user to choose modules unless they explicitly want manual control.

Mandatory brainstorm core:
- Brainstorm must always run before the visible debate.
- Brainstorm must internally use the full BMAD ideation set by default in this explicit baseline stack: 5 Whys, Starbursting, Six Thinking Hats, SCAMPER, Mind Mapping, Brainwriting, Reverse Brainstorming, and SWOT.
- Treat that BMAD brainstorm set as a fixed baseline. Do not silently drop, merge away, swap out, or skip any of those 8 techniques, even when the prompt is narrow.
- In that brainstorm phase, also apply at least 2 extra KHON cognitive modules during ideation.
- Select those extra KHON ideation modules dynamically at runtime from the curated 21-module set based on prompt/context fit rather than from a permanently locked pair.
- Prefer a non-overlapping ideation pair so each chosen module adds a meaningfully different reasoning move.
- Use the fallback pair `cog.second_order_observation` and `cog.consequences` only when no clearly better pair emerges.
- Use the extra KHON modules inside ideation itself, not only later in debate or synthesis.
- If the user forces a small module override set, preserve the BMAD ideation set anyway and use the override mainly to shape the debate phase.
- Manual module override remains optional advanced control, not part of the default one-command UX.

Module selection rules:
- For the visible debate, prefer 3-5 modules beyond the mandatory brainstorm core in normal mode.
- In zero-config mode with no explicit `focus=`, `personas=`, or `modules=`, choose a balanced debate subset that covers value framing, market or customer reality, uncertainty reduction, execution consequences, governance or risk pressure, and skeptical challenge. Achieve that balance with a mixed module set rather than a narrow best-fit pack.
- If explicit `modules=` is present, treat that override as the visible debate set and do not silently pad it with unrelated modules beyond what is needed for the mandatory brainstorm baseline.
- In `:max`, expand debate-phase module coverage beyond the normal baseline when useful so more distinct reasoning lenses actively pressure the conversation.
- Cover at least 3 different categories when possible.
- For technical / architecture topics, bias toward `cog.consequences`, `cog.black_swan`, `cog.reverse_brainstorming`, `cog.monte_carlo`, and `cog.second_order_observation`.
- For product / business / marketing topics, bias toward `cog.swot`, `cog.scamper`, `cog.pareto`, `cog.making_of`, and `cog.face_it`.
- For people / partnership / org-change topics, bias toward `cog.role_playing`, `cog.conflict_resolution`, `cog.friend_request_trust`, and `cog.double_loop_learning`.
- For governance / compliance / risk topics, bias toward `cog.black_swan`, `cog.swiss_cheese`, `cog.second_order_observation`, `cog.monte_carlo`, and `cog.conflict_resolution`.
- For execution / prioritization topics, bias toward `cog.pareto`, `cog.eisenhower`, `cog.result_optimisation`, and `cog.consequences`.
- `focus=innovation` means differentiated options that still create value, survive scrutiny, and can realistically ship.
- Innovation mapping should be explicit when used: persona anchor = `innovator`; ideation modules = usually `cog.scamper` plus `cog.making_of` or `cog.role_playing`; pressure-test modules = usually `cog.second_order_observation`, `cog.consequences`, and `cog.black_swan` when downside asymmetry matters.
- For `focus=innovation`, show that mapping clearly in the selected roster and module rationale so the user can see where novelty enters and where it gets pressure-tested.
- Record why each module was selected.
- Record which 2+ KHON modules were injected into brainstorm ideation and why they were the best non-overlapping fit.
- Normal behavior should keep brainstorm reporting concise after the full internal ideation pass.
- Normal behavior should remain BMAD-complete with selective KHON augmentation rather than maximal module spread.
- `:max` should expand ideation breadth materially: more divergent angles, more candidate ideas, and broader cluster coverage before the debate starts.
- `:max` should also increase debate-phase cognitive pressure: more active module interplay, more cross-examination of claims, and wider coverage of unresolved trade-offs.
- Use the generated module catalog summary below as the fast index before reading full module cards.

Use the embedded cognitive module cards below as the methodology source.
When a module is selected, apply its methodology and application notes during the debate.
