# ARCHIVE Command

## Memory Bank Integration
Reads: `memory-bank/tasks.md` (single source — has everything needed)
Reads: `memory-bank/reflection/reflection-[task_id].md` (L2-4 only)
Creates: `memory-bank/archive/archive-[task_id].md`
Updates: `tasks.md`, `activeContext.md`
Clears: `progress.md`

## Rule Loading
Step 1: `isolation_rules/main.mdc` only
NO level-specific rules — archive is documentation, not logic.

## Workflow

### Gate Check
Verify in tasks.md:
- `reflection_status: COMPLETE`

IF fails → redirect to /reflect.

### Level 1: Minimal Archive (no archive file)
Append to tasks.md then done:
archive_status: COMPLETE
archived_at: [date]

Reset activeContext.md: clear current task fields.
**Total token cost: ~200 tokens.**

### Level 2: Compact Archive File
Create `archive-[task_id].md` with ONLY:
[task_id] | [feature_name] | L2 | [date]
What was built
[2-3 lines]
Key decision
[1-2 lines]
Reuse note
[1 line — what future tasks can copy from this]

### Level 3-4: Standard Archive File
[task_id] | [feature_name] | L[n] | [date]
Summary
[3-5 lines]
Implementation
[Plugin commands used, architecture decisions]
Test Results
[From build_log — pass/fail counts]
Lessons → Reuse
[Top 3 only, each 1-2 lines]
Refs

reflection: reflection-[task_id].md
creative: creative-[feature].md (L3-4)


### Update Memory Bank (always, all levels)
tasks.md:     task_status: COMPLETE, archive_status: COMPLETE
activeContext.md: reset all fields to empty/ready
progress.md:  clear completed task data, keep file structure

## Hard Rules
- NO loading creative files unless L3-4 AND archive needs specific design rationale
- Archive file max: L2=1 page, L3=2 pages, L4=3 pages
- Do NOT rewrite what's already in reflection — just reference it
- L1 never creates an archive file

## Next Step → /van (next task)