## Display Summary to User

Use this output contract:

```md
## [Localized objective heading, e.g. Thai: `สรุปโจทย์` / English: `Problem Summary`]
- [Localized inferred-task label]
- [Localized assumptions label]
- [Localized emphasis label]

## [Localized roster heading, e.g. Thai: `คนในวงสนทนา` / English: `Voices in the Room`]
- Name (Role — short trait) — [Localized Business/Value angle label]: [Localized why-this-person-is-here text]
- Name (Role — short trait) — [Localized Market/Customer angle label]: [Localized why-this-person-is-here text]
- Name (Role — short trait) — [Localized Research/Uncertainty angle label]: [Localized why-this-person-is-here text]
- Name (Role — short trait) — [Localized Execution/System angle label]: [Localized why-this-person-is-here text]
- Name (Role — short trait) — [Localized Governance/Risk angle label]: [Localized why-this-person-is-here text]
- Name (Role — short trait) — [Localized Challenge/Skeptic angle label]: [Localized why-this-person-is-here text]

## [Localized lenses heading, e.g. Thai: `มุมคิดที่หยิบมาใช้` / English: `Thinking Lenses Used`]
| [Localized module label] | [Localized selection-method label] | [Localized relevance label] |
|---|---|---|

## [Localized idea clusters heading, e.g. Thai: `ประเด็นที่แตกออกมา` / English: `Emerging Threads`]
- [Localized cluster summary]
- [Localized cluster summary]

## [Localized idea harvest heading, e.g. Thai: `ไอเดียที่ควรหยิบมาคิดต่อ` / English: `Ideas Worth Carrying Forward`]
- [Localized strong option worth debating]
- [Localized contrarian or risky idea worth pressure-testing]
- [Localized hybrid idea worth combining]
- [Localized fragment worth keeping alive]

## [Localized discussion heading, e.g. Thai: `ข้อถกเถียง` / English: `Debate`]
Name (Role — short trait): ...
Name (Role — short trait): ...
Name (Role — short trait): ...
Name (Role — short trait): ...

## [Localized governance heading, e.g. `เช็กความเสี่ยงและเงื่อนไข`]
| ข้อเสนอ | สถานะ | เหตุผล | กรอบที่ปลอดภัยกว่า / เงื่อนไขกำกับ |
|---|---|---|---|

## [Localized landing heading, e.g. `บทสรุปที่ตกผลึก`]
### [Localized agreements heading, e.g. `มุมที่เห็นตรงกัน`]
- ...

### [Localized disagreements heading, e.g. `มุมที่ยังเห็นต่าง`]
- ...

### [Localized recommendation heading, e.g. `ข้อเสนอแนะ`]
- ...

### [Localized rationale heading, e.g. `เหตุผลที่ไปทางนี้`]
- ...

### [Localized open questions heading, e.g. `คำถามที่ยังต้องหาคำตอบ`]
- ...

### [Localized next steps heading, e.g. `ขั้นถัดไป`]
1. ...
2. ...
3. ...
```

Output-style rules:
- Keep the prompt framework in English, but render the final user-facing answer in the user's language.
- Match the final answer language to the user's prompt language. Do not default to Thai unless the user is writing in Thai.
- For Thai output, prefer headings like `สรุปโจทย์`, `คนในวงสนทนา`, `มุมคิดที่หยิบมาใช้`, `ประเด็นที่แตกออกมา`, `ไอเดียที่ควรหยิบมาคิดต่อ`, `ข้อถกเถียง`, `เช็กความเสี่ยงและเงื่อนไข`, `บทสรุปที่ตกผลึก`, `มุมที่เห็นตรงกัน`, `มุมที่ยังเห็นต่าง`, `ข้อเสนอแนะ`, and `ขั้นถัดไป` instead of stiff direct translations such as `Objective`, `Roster`, `Lenses`, or `Governance`.
- For English output, prefer natural headings such as `Problem Summary`, `Voices in the Room`, `Thinking Lenses Used`, `Emerging Threads`, `Ideas Worth Carrying Forward`, `Debate`, `Risk Check`, `What We Landed On`, `Shared Ground`, `Open Disagreements`, `Recommendation`, and `Next Steps`.
- In zero-config mode, make the 6 required balance-first angles visibly explicit in the roster section unless the user explicitly overrides personas.
- Localize every user-facing section heading and micro-label into the user's language. Avoid mixed-language headings unless the user explicitly wants that.
- Reduce unexplained jargon in the active output language. If an English term is necessary in Thai output, explain it in Thai on first use before using the English shorthand again.
- If module IDs remain in English, keep the explanation column plain and human so the user understands why each module matters without knowing the internal label system.
- Brainstorm must happen before debate every time, but only show the concise outcomes of brainstorming rather than a long worksheet dump.
- In normal mode, show BMAD-complete brainstorming outcomes concisely and keep KHON augmentation selective.
- In `:max` mode, show a broader idea-space harvest and more cluster breadth before the debate.
- In `:max` mode, let the visible discussion also reflect higher debate-phase module coverage and stronger cognitive pressure, not just a larger brainstorm harvest.
- The discussion should feel like a real party conversation, not a transcript of formal rounds.
- Do not print the words `Round 1`, `Round 2`, or `Round 3` in the final answer.
- The discussion section should usually contain at least 16-22 turns by default.
- Turns should be short, sharp, and responsive to one another.
- The closing synthesis should be friendlier, clearer, and more explanatory than the discussion turns.
- In the closing synthesis, prefer plain spoken recommendations over sterile report language.

If the user requested `help`, show:
- what the command does
- default behavior
- optional controls
- 4 short usage examples
