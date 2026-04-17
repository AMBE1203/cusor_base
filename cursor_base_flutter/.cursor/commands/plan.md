# PLAN Command - Task Planning

## Memory Bank Integration
Reads: `memory-bank/tasks.md` (complexity_level, task description)
Reads: `memory-bank/activeContext.md`
Updates: `memory-bank/tasks.md` (implementation plan + phase flags)

## Rule Loading
Step 1 (always, 1 file):
- `isolation_rules/main.mdc`

Step 2 (conditional, 1-2 files max):
- L2: `Level2/workflow-level2.mdc`
- L3: `Level3/planning-comprehensive.mdc`
- L4: `Level4/architectural-planning.mdc` + `Level4/workflow-level4.mdc`

DO NOT load: `memory-bank-paths.mdc`, `plan-mode-map.mdc`, task-tracking files
These are reference docs — AI does not need to read them to create a plan.

## Workflow

### Step 1: Read Context
Read tasks.md → extract: complexity_level, task description, plugin_available.
Read activeContext.md → extract: affected_files (if any prior work exists).

### Step 2: Scan Codebase (targeted, not broad)
Look at files directly relevant to the task only.
Do NOT scan entire project structure — wasteful.

### Step 3: Create Plan (write directly to tasks.md)
Append to tasks.md:
Implementation Plan

phases: [list]
files_to_modify: [list]
creative_required: [true/false]
creative_components: [list if true]

Checklist

phase 1: ...
phase 2: ...


L2: 3-5 checklist items, no phases.
L3: phases with components, flag creative items.
L4: phased with architecture notes, flag creative + security items.

### Step 4: Technology Validation (L3-4 only)
Verify dependencies exist. Note conflicts. Max 5 lines in tasks.md.

## Hard Rules
- Plan lives in tasks.md — no separate plan file
- creative_required field is mandatory
- L2 plan must fit in <20 lines in tasks.md
- Do not read progress.md at plan phase — not written yet

## Next Steps
- creative_required: true → /creative
- creative_required: false → /build