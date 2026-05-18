# PLAN Command - Task Planning

## Memory Bank Integration
Reads: `memory-bank/tasks.md` (complexity_level, task description)
Reads: `memory-bank/activeContext.md`
Updates: `memory-bank/tasks.md` (implementation plan + phase flags)

## Rule Loading
### Step 1 (always, 1 file):
- `isolation_rules/main.mdc`

### Step 2 (conditional, 1-2 files max):
- L2: `Level2/workflow-level2.mdc`
- L3: `Level3/planning-comprehensive.mdc`
- L4: `Level4/architectural-planning.mdc` + `Level4/workflow-level4.mdc`

DO NOT load: `memory-bank-paths.mdc`, `plan-mode-map.mdc`, task-tracking files
These are reference docs — AI does not need to read them to create a plan.

### Step 3 (if is first time):
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

### Step 1: Read Context
Read tasks.md → extract: complexity_level, task description, plugin_available.
Read activeContext.md → extract: affected_files (if any prior work exists).

### Step 2: GitNexus Architecture Scan (replaces broad codebase scan)
Call MCP tool: `list_repos`
IF unavailable → skip to Step 3, log: "gitnexus_unavailable", proceed with manual scan.
IF available:

  2a. Symbol discovery (replaces Step 3's manual file hunting)
      Call: `query({query: "<task description keywords>"})`
      Extract: relevant symbols + file locations → use as files_to_modify draft
  
  2b. Dependency mapping (L3-4 only)
      For each primary symbol from 2a:
        Call: `context({name: "<symbol>"})`
        Extract: incoming.calls → blast_radius candidates
                 outgoing.calls → files that must be understood
  
  2c. Pre-plan impact check (L3-4 only)
      Call: `impact({target: "<primary_symbol>", direction: "upstream", minConfidence: 0.8})`
      IF Depth 1 non-empty → add to tasks.md as blast_radius
      IF blast_radius > 5 symbols → upgrade complexity_level by 1

  DO NOT open any file not returned by query results.

### Step 3: Create Plan (write directly to tasks.md)
Append to tasks.md:
Implementation Plan

phases: [list]
files_to_modify: [from GitNexus query — not manual guess]
blast_radius: [from impact() — L3-4 only, else omit]
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

### Step 5: Route
- L1 → load `Level1/workflow-level1.mdc` → proceed to /build directly
- L2-4 → stop here, tell user to run /plan


## Hard Rules
- Plan lives in tasks.md — no separate plan file
- creative_required field is mandatory
- L2 plan must fit in <20 lines in tasks.md
- Do not read progress.md at plan phase — not written yet
- files_to_modify must come from GitNexus query when available — manual listing is fallback only

## Next Steps
- L1 → /build
- L2-4 → /plan
  
