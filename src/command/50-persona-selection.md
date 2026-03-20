### Part 3: Derive Dynamic Personas

Select 4-6 personas that fit the actual problem.

Balance-first default:
- If the user gives no explicit `focus=`, `personas=`, or `modules=`, use 6 visible personas by default so the output explicitly covers all 6 required angles.
- Business / Value → usually `product-strategist`
- Market / Customer → usually `marketer`; use `customer-advocate` instead when adoption friction, trust, rollout, or stakeholder experience matters more than external positioning
- Research / Uncertainty → `researcher`
- Execution / System → `operator` for delivery and operational realism, or `architect` when system shape, coupling, or technical structure is central
- Governance / Risk → `governor`
- Challenge / Skeptic → `skeptic`
- Keep these angles visibly distinct. Do not collapse them into a narrow best-fit trio by default.
- In the final `คนในวงสนทนา` section, label each roster entry with its angle so the user can see the balance at a glance.

Hard requirements:
- Always include one business / value lens.
- Always include one market / customer lens.
- Always include one research / uncertainty lens.
- Always include one execution / system lens.
- Always include one governance / risk lens.
- Always include one skeptical or critical lens.
- In zero-config mode, keep all 6 angle labels visible in the output.
- Do not default to a dev-only panel unless the prompt is clearly dev-only and the user explicitly narrowed the panel.
- Do not use a brittle fixed roster when the prompt obviously calls for a better swap inside one of the required angles.

Narrowing rules:
- If explicit `personas=` is present, use that roster as the visible panel and do not silently add balance-first defaults.
- If explicit `focus=` is present without `personas=`, narrow by reweighting or swapping the balanced roster rather than rebuilding from scratch.
- `focus=tech` usually favors `architect` over `operator` and keeps business / market voices concise but still present unless the prompt is clearly internal-only.
- `focus=product` or `focus=biz` should keep `product-strategist` central and keep customer / market pressure active.
- `focus=ops` should make `operator` central and keep `governor` and `skeptic` louder than usual.
- `focus=research` should make `researcher` central and surface confidence, evidence gaps, and unknowns early.
- `focus=marketing` should make `marketer` central and keep value, customer trust, and execution realism nearby.
- `focus=governance` should make `governor` central and keep `skeptic` and `researcher` active.
- `focus=innovation` means useful differentiation, not novelty theater. Make that explicit by including `innovator` as the novelty voice, keeping `product-strategist` for value, keeping a market / customer voice for pull, keeping `researcher` for uncertainty, keeping an execution / system voice for shipability, and keeping risk pressure alive through `skeptic`, `governor`, or both depending on room.

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
