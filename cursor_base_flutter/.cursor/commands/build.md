# BUILD Command - Code Implementation (Enhanced with Flutter Cursor Plugin)

## Step 0: Read State First (Before Loading Anything)
Read ONLY these two files first:
- `memory-bank/tasks.md` → extract: complexity_level, current_phase, plugin_available
- `memory-bank/activeContext.md` → extract: feature_name, affected_files

Then load rules conditionally based on extracted state.

## Step 0b: GitNexus Build-Time Verification  

### 0b-1. Detect changes since plan  
Call: `detect_changes({scope: "all"})`  
IF changed_symbols intersects blast_radius (from tasks.md) → re-run impact()  
IF no intersection → proceed, plan still valid  

### 0b-2. Scope gate  
Call: `query({query: "<feature_name>"})`  
files_to_read = query result only.  
Do NOT read files outside this list.  

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
Execute skill: `skills/security-audit/SKILL.md`  
Scope: planned changes from tasks.md only.  
Write findings to tasks.md build_log before proceeding.  

### 5b. Implementation  
Note: Codex will review your output once you are done"  
Execute the correct skill based on tasks.md state:  

IF figma_node_id OR figma_url exists:  
  → Execute: `skills/build-flutter-features/figma-to-flutter.md`  
  → Use Figma MCP to fetch design spec  
  → Implement UI from Figma output  
  IF Figma MCP unavailable → STOP.  
     Tell user: "Figma MCP not configured.  
     See docs/figma-mcp-setup.md or remove figma_node_id to implement from plan."  

ELSE:  
  → Execute: `skills/build-flutter-features/SKILL.md`  
  → Implement feature from tasks.md plan  

### 5c. Immediate test (do not batch)  
Execute skill: `skills/write-flutter-tests/SKILL.md`  
Scope: affected_files extracted in Step 0.  
Run immediately after 5b — do not defer.  
Do not batch — run immediately after implementation.  

### Test Result Reporting (Required)  
After execution, AI MUST report:  

- total_test_cases: [number]  
- passed: [number]  
- failed: [number]  

### Evaluation Rule  
- IF failed > 0 → mark test_result: FAIL  
- ELSE → mark test_result: PASS  


## Step 6: Update Memory Bank (Structured Format)  
Append to tasks.md using EXACTLY this format:  
Build Log - [timestamp]  

phase: [1/2/3]  
plugin_command: [exact command used]  
result: [PASS/FAIL/PARTIAL]  
checkpoint: [next_phase_name]  
issues: [none | list]  


## Step 7: Final Review (Always — Both Required)  

Execute in order:  
1. `skills/review-flutter-code/SKILL.md`  
2. `skills/security-audit/SKILL.md`  

### Evaluation Rule  
- IF any issue, error, or fail case is reported from either step → mark:  
  security-review: FAIL  
- ELSE (no issues found) → mark:  
  security-review: PASS  

Update tasks.md:  

checkpoint: COMPLETE  
build_status: DONE  
security-review: [PASS/FAIL based on evaluation]  


## Fallback Policy  
IF plugin command fails:  
1. Log failure in tasks.md with above format  
2. Ask user: retry | skip | abort  
3. NEVER fall back to manual coding silently  


## Hard Rules (Always Apply)
- All implementation via skill files — no ad-hoc code generation
- Dart MCP is for validation only — not code generation
- Figma MCP only when figma_node_id or figma_url present in tasks.md
- Skills are executed directly — never call commands from within build.md
- Both Step 7 reviews are mandatory — skipping either is not allowed
- Manual code editing is **strictly forbidden** in this /build command.
- Manual Dart/Flutter code edits are forbidden — use plugin or stop and ask user
- Official rules must be synced before proceeding — if missing, STOP
