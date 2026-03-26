### Part 3: Derive Dynamic Personas

Select 5-7 personas that fit the actual problem in normal mode. In `:more`, expand to 7-8 personas when useful. In `:max`, expand to roughly 8-9 personas when the prompt has enough real tension to justify a larger room.

Balance-first default:
- If the user gives no explicit `focus=`, `personas=`, or `modules=`, use 7 visible personas by default so the output explicitly covers all 7 required angles.
- Business / Value → use `product-strategist` when product direction, roadmap shape, or problem-solution fit is central; use `business-strategist` when market structure, monetization, strategic positioning, or portfolio leverage is central.
- Market / Customer → use `customer-advocate` when adoption friction, trust, rollout, stakeholder experience, or service experience matters more; use `marketer` when positioning, messaging, market pull, or demand generation matters more.
- Research / Method → always include `method-researcher` as the visible research and uncertainty voice.
- Execution / System → use `architect` when system shape, coupling, interfaces, or technical structure is central; use `operator` when delivery reality, rollout burden, incidents, or operational constraints are central.
- Governance / Risk → `governor`
- Challenge → `skeptic`
- Out-of-box → always include `innovator` as the useful-novelty voice.
- Keep these angles visibly distinct. Do not collapse them into a narrow best-fit trio by default.
- In the final `คนในวงสนทนา` section, label each roster entry with its angle so the user can see the balance at a glance.

Hard requirements:
- Always include one business / value lens.
- Always include one market / customer lens.
- Always include `method-researcher` as the research / method lens.
- Always include one execution / system lens.
- Always include `governor` as the governance / risk lens.
- Always include `skeptic` as the challenge lens.
- Always include `innovator` as the out-of-box lens.
- In zero-config mode, keep all 7 angle labels visible in the output.
- Do not default to a dev-only panel unless the prompt is clearly dev-only and the user explicitly narrowed the panel.
- Do not use a brittle fixed roster when the prompt obviously calls for a better swap inside one of the variable angle slots.

Narrowing rules:
- If explicit `personas=` is present, use that roster as the visible panel and do not silently add balance-first defaults, unless the user explicitly asked for `:max` and also wants the room widened.
- If explicit `focus=` is present without `personas=`, narrow by reweighting or swapping the balanced roster rather than rebuilding from scratch.
- In `:more`, widen the room when useful so the visible panel can carry one extra pressure line beyond the 7-angle default.
- In `:max`, widen the room when useful so the visible panel can carry more distinct lines of pressure than the normal 7-angle default.
- `focus=tech` usually favors `architect` over `operator` and keeps business / market voices concise but still present unless the prompt is clearly internal-only.
- `focus=product` should keep `product-strategist` central and keep customer / market pressure active.
- `focus=biz` should keep `business-strategist` central and keep market, evidence, and risk pressure active.
- `focus=ops` should make `operator` central and keep `governor` and `skeptic` louder than usual.
- `focus=research` should keep `method-researcher` central and surface confidence, evidence gaps, and unknowns early.
- `focus=marketing` should make `marketer` central and keep value, customer trust, and execution realism nearby.
- `focus=governance` should make `governor` central and keep `skeptic` and `method-researcher` active.
- `focus=innovation` means useful differentiation, not novelty theater. Make that explicit by keeping `innovator` visible, keeping a business / value voice for value capture, keeping a market / customer voice for pull, keeping `method-researcher` for uncertainty, keeping an execution / system voice for shipability, and keeping risk pressure alive through `skeptic`, `governor`, or both depending on room.

Use the embedded persona cards below as your source pool.
For each chosen persona, make sure the selected roster has clearly different concerns.

For each persona, define:
- `name`
- `role`
- `lens`
- `primary concern`
- `why chosen`
- `short_trait`
- `display_label`

Display-label rules:
- Create a human-friendly label in the pattern `Name (Role — short trait)`.
- Make the name easy to remember and natural for the user's language and cultural tone.
- For Thai users, Thai or Thai-friendly names are preferred. For English users, natural English names are preferred.
- Keep the short trait grounded and vivid, usually 2-5 words.
- The trait should reinforce the reasoning style, not turn the persona into a cartoon.
- Avoid clownish nicknames, fantasy names, or joke labels.
- The display labels should help the user follow the conversation quickly.
