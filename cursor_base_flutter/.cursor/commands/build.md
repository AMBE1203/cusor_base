# VAN Command - Initialization & Entry Point

## Memory Bank Integration
Reads: `memory-bank/tasks.md` (if exists)
Updates: `memory-bank/tasks.md`, `memory-bank/activeContext.md`

## Rule Loading
Step 1 (always, 4 files):
```
Load: .cursor/rules/isolation_rules/main.mdc
Load: .cursor/rules/isolation_rules/Core/memory-bank-paths.mdc
Load: .cursor/rules/isolation_rules/Core/platform-awareness.mdc
Load: .cursor/rules/isolation_rules/Core/file-verification.mdc
```

### Step 2: Load VAN Mode Map
```
Load: .cursor/rules/isolation_rules/visual-maps/van_mode_split/van-mode-map.mdc
```


### Step 3 (conditional after complexity determined):
- L1 only: `Level1/workflow-level1.mdc`
- L2-4: skip — /plan handles its own rules

DO NOT load: `memory-bank-paths.mdc`, `file-verification.mdc`, `van-mode-map.mdc`
These cost tokens and provide no routing value at VAN phase.

### Step 4 (if is first time):
## AUTO PROJECT DISCOVERY (EXECUTION)

When ALL conditions below are true:
- memory-bank/ directory exists
- At least one of the following files is empty:
  - projectbrief.md
  - productContext.md
  - systemPatterns.md
  - techContext.md

THEN perform the following actions:

### 1. Analyze Project Codebase
- Explore repository structure
- Identify entry points (main.dart, index.js, etc.)
- Read key files:
  - pubspec.yaml
  - package.json
  - README.md
  - build.gradle (if exists)

### 2. Infer Project Information
Determine:
- Project purpose
- Core features
- Technology stack
- Architecture patterns
- Key modules and structure

### 3. Populate Memory Bank Files

For each file below, if it is empty → write content:

#### memory-bank/projectbrief.md
Write:
- Project overview
- Main goals
- Scope

#### memory-bank/productContext.md
Write:
- Target users
- Use cases
- Product behavior

#### memory-bank/systemPatterns.md
Write:
- Architecture pattern
- Module structure
- Design decisions

#### memory-bank/techContext.md
Write:
- Languages
- Frameworks
- Libraries
- Constraints

### STRICT RULES:
- Do NOT overwrite non-empty files
- Do NOT guess — only use evidence from code
- If unknown → write "Unknown"
- Keep output concise and structured

## Workflow

### Step 1: Platform Detection
Detect OS → set path separator → store in activeContext.md (1 line).

### Step 2: Memory Bank Check
IF `memory-bank/` missing → create structure with empty files.
IF exists → read `tasks.md` only (skip other files).

### Step 3: Plugin Availability Check (Flutter projects)
IF `.cursor/rules/flutter-plugin-policy-priority.mdc` exists:
- Check flutter-cursor-plugin available
- Store: `plugin_available: true/false` in tasks.md
- IF false → warn user before proceeding

### Step 4: Complexity Determination
Analyze task → assign L1/L2/L3/L4.
Write to tasks.md:
Task: [name]

complexity: L[n]
plugin_available: [true/false]
build_checkpoint: pending
reflection_status: pending
archive_status: pending


### Step 5: Route
- L1 → load `Level1/workflow-level1.mdc` → proceed to /build directly
- L2-4 → stop here, tell user to run /plan

## Hard Rules
- Never load level rules for L2-4 at VAN phase — /plan owns that
- plugin_available check is mandatory for Flutter projects
- Total files loaded: max 3 (main + platform + L1 workflow if needed)

## Next Steps
- L1 → /build
- L2-4 → /plan
