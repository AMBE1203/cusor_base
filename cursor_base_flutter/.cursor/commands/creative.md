# CREATIVE Command - Design Decisions

## Memory Bank Integration
Reads: `memory-bank/tasks.md` (creative_components list)
Creates: `memory-bank/creative/creative-[feature].md` (1 file per component)
Updates: `memory-bank/tasks.md` (design decisions)

## Rule Loading
Step 1 (always, 1 file):
- `isolation_rules/main.mdc`

Step 2 (load only when first creative component starts, 1 file):
- `isolation_rules/Core/creative-phase-enforcement.mdc`

Step 3 (lazy — load only for matching component type, 1 file):
- Architecture → `CreativePhase/creative-phase-architecture.mdc`
- UI/UX → `CreativePhase/creative-phase-uiux.mdc`
- Algorithm → `CreativePhase/creative-phase-algorithm.mdc`

DO NOT load: `creative-phase-metrics.mdc`, `creative-mode-map.mdc`, `memory-bank-paths.mdc`

## Workflow

### Gate Check
Read tasks.md → verify `creative_required: true` and `creative_components` list exists.
IF missing → STOP, redirect to /plan.

### For Each Component (sequential, not parallel)
Load the matching Step 3 rule file ONLY when processing that component.

**🎨 ENTERING CREATIVE PHASE: [type] — [component name]**

1. State requirements (3-5 bullet points from tasks.md)
2. Generate options (2-3 max — not 4, cognitive overhead not worth it for L3)
3. For each option: name + pros (2) + cons (2) — table format
4. Select + justify in 2-3 lines
5. Write implementation guidelines (5 bullet points max)

**🎨 EXITING CREATIVE PHASE**

Write to `creative-[component].md`:
Creative: [component] | [type] | [date]
Decision: [option chosen]
[2-line rationale]
Implementation Guidelines

[5 bullet points max]

Options Considered
OptionProConA......B......

Update tasks.md: mark component as `creative_done: true`.

### After All Components Complete
Update tasks.md: `creative_status: COMPLETE`

## Hard Rules
- Max 2-3 options per component — more is analysis paralysis, not quality
- creative file max 1 page
- Unload previous component's rule file before loading next (if different type)

## Next Steps → /build