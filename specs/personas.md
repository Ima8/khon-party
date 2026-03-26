# Personas

## Canonical persona pool v1

The canonical source pool contains exactly 22 personas:

1. product-strategist
2. business-strategist
3. customer-advocate
4. marketer
5. method-researcher
6. architect
7. operator
8. governor
9. skeptic
10. innovator
11. data-analyst
12. behavioral-scientist
13. scenario-planner
14. finance-controller
15. sales-strategist
16. partnership-lead
17. ux-designer
18. community-lead
19. program-manager
20. change-manager
21. process-designer
22. competitive-analyst

Pruned from v1:
- content-strategist
- support-lead

Rename rule:
- `method-researcher` replaces the old generic `researcher` role. Do not keep both.

## Goal

Select a context-fit room instead of using one rigid fixed panel every time.

## Balance-first default

Default `/khon-party` should show 7 visible personas, not 6.

Required visible slots:
- Business / Value → `product-strategist` or `business-strategist` depending on context
- Market / Customer → `customer-advocate` or `marketer` depending on context
- Research / Method → `method-researcher` (always visible)
- Execution / System → `architect` or `operator` depending on context
- Governance / Risk → `governor`
- Challenge → `skeptic`
- Out-of-box → `innovator` (always visible)

Selection notes:
- Keep the room balance-first by default.
- Keep `method-researcher` and `innovator` visibly present in the normal default room.
- Swap only the variable slots when context clearly calls for it.
- `/khon-party:more` usually widens to 7-8 visible personas when useful.
- `/khon-party:max` usually widens to roughly 8-9 visible personas when useful.

## Anti-patterns

Avoid:
- using pruned personas such as `content-strategist` or `support-lead`
- keeping both `researcher` and `method-researcher`
- collapsing the default room into a narrow single-discipline roster when the prompt is cross-functional
- inventing generic personas with no clear concern
- fake disagreement where everyone agrees immediately
