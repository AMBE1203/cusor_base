# BUILD Command - Code Implementation (Enhanced with Flutter Cursor Plugin)

## Step 0: Read State First (Before Loading Anything)
Read ONLY these two files first:
- `memory-bank/tasks.md` → extract: complexity_level, current_phase, plugin_available
- `memory-bank/activeContext.md` → extract: feature_name, affected_files

Then load rules conditionally based on extracted state.

## Step 1: Load Minimum Core (Always - 3 files max)
- `isolation_rules/main.mdc`
- `isolation_rules/Core/command-execution.mdc`
- `flutter-plugin-policy-priority.mdc`  ← single source of truth for plugin rules

## Step 2: Load Level-Specific Rules (Conditional - 1-2 files)
IF complexity == 1: load Level1/workflow-level1.mdc ONLY
IF complexity == 2: load Level2/workflow-level2.mdc ONLY  
IF complexity >= 3: load Level3/implementation-intermediate.mdc + phased-implementation.mdc

## Step 3: Official Rules Gate
IF flutter-official-ai-rules.mdc missing → STOP, prompt sync.
IF exists → proceed (do NOT re-read if already in context)

## Step 4: Resume Check (Critical for Token Saving)
Read `memory-bank/tasks.md` → check `build_checkpoint` field.
IF checkpoint exists → skip to that phase, do NOT restart.
IF no checkpoint → start from phase 1.

## Step 5: Execute Plugin Commands

### 5a. Pre-implementation security check (Level 3-4 only)
security-review --scope=planned-changes

### 5b. Implementation
implement-flutter-feature [feature from tasks.md]

### 5c. Immediate test (do not batch)
generate-flutter-tests [affected files from step 0]

## Step 6: Update Memory Bank (Structured Format)
Append to tasks.md using EXACTLY this format:
Build Log - [timestamp]

phase: [1/2/3]
plugin_command: [exact command used]
result: [PASS/FAIL/PARTIAL]
checkpoint: [next_phase_name]
issues: [none | list]


## Step 7: Final Review (Always)
review-flutter-code
security-review

Update tasks.md:

checkpoint: COMPLETE
build_status: DONE


## Fallback Policy
IF plugin command fails:
1. Log failure in tasks.md with above format
2. Ask user: retry | skip | abort
3. NEVER fall back to manual coding silently

## Hard Rules (Always Apply)
- End EVERY build with: `review-flutter-code` then `security-review` — no exceptions
- Plugin commands have no leading `/` (correct: `implement-flutter-feature`, not `/implement-flutter-feature`)  
- Manual Dart/Flutter code edits are forbidden — use plugin or stop and ask user
- Official rules must be synced before proceeding — if missing, STOP
