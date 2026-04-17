# REFLECT Command

## Memory Bank Integration
Reads: `memory-bank/tasks.md` (build_log, plugin_commands_log, checkpoint)
Reads: `memory-bank/creative/creative-*.md` (Level 3-4 only, lazy)
Creates: `memory-bank/reflection/reflection-[task_id].md`
Updates: `memory-bank/tasks.md`

## Rule Loading
Step 1: `isolation_rules/main.mdc` (always)
Step 2 (conditional, 1 file only):
- L1 → skip (reflect inline, no file needed)
- L2 → `Level2/reflection-basic.mdc`
- L3 → `Level3/reflection-intermediate.mdc`
- L4 → `Level4/reflection-comprehensive.mdc`

## Workflow

### Gate Check
Read `tasks.md`, verify:
- `checkpoint: COMPLETE`
- `security-review` in log with PASS

## Fallback Policy
IF fails:
1. Tell user what's missing.
2. Ask user: retry | skip | abort
3. NEVER fall back to manual coding silently

### Extract (from tasks.md build_log only — no re-reading other files)
- feature_name, complexity_level, task_id
- plugin commands executed + results
- any FAIL/PARTIAL entries

### Level 1: Inline Reflect (no file created)
Append directly to tasks.md:
Reflect [task_id]

what_worked: [1 line]
issue: [1 line or none]
reflection_status: COMPLETE

→ Skip to /archive immediately.

### Level 2-4: Create Reflection File
`memory-bank/reflection/reflection-[task_id].md`:
Reflect: [task_id] | [feature_name]
Result: PASS ✓
Plugin Log
CommandResultNotes[from build_log]
What Worked / Challenges
[2-3 lines max per section — based on log data, not memory]
Lessons (L3-4 only)
[Concrete, actionable — reference specific plugin commands]
Improvements (L4 only)
[Process or architecture — 2-3 items max]

### Update tasks.md

reflection_status: COMPLETE
reflection_doc: reflection-[task_id].md


## Hard Rules
- L1: no reflection file — inline only
- Base ALL observations on build_log data
- Max 1 page for L2, 2 pages for L3-4
- Do NOT re-read progress.md — data already in tasks.md build_log

## Next Step → /archive