# PLAN Command - Task Planning

This command creates detailed implementation plans based on complexity level determined in VAN mode.

## Memory Bank Integration

Reads from:
- `memory-bank/tasks.md` - Task requirements and complexity level
- `memory-bank/activeContext.md` - Current project context
- `memory-bank/projectbrief.md` - Project foundation (if exists)

Updates:
- `memory-bank/tasks.md` - Adds detailed implementation plan

## Progressive Rule Loading

### Step 1: Load Core Rules
```
Load: .cursor/rules/isolation_rules/main.mdc
Load: .cursor/rules/isolation_rules/Core/memory-bank-paths.mdc
```

### Step 2: Load PLAN Mode Map
```
Load: .cursor/rules/isolation_rules/visual-maps/plan-mode-map.mdc
```

### Step 3: Load Complexity-Specific Planning Rules
Based on complexity level from `memory-bank/tasks.md`:

**Level 2:**
```
Load: .cursor/rules/isolation_rules/Level2/task-tracking-basic.mdc
Load: .cursor/rules/isolation_rules/Level2/workflow-level2.mdc
```

**Level 3:**
```
Load: .cursor/rules/isolation_rules/Level3/task-tracking-intermediate.mdc
Load: .cursor/rules/isolation_rules/Level3/planning-comprehensive.mdc
Load: .cursor/rules/isolation_rules/Level3/workflow-level3.mdc
```

**Level 4:**
```
Load: .cursor/rules/isolation_rules/Level4/task-tracking-advanced.mdc
Load: .cursor/rules/isolation_rules/Level4/architectural-planning.mdc
Load: .cursor/rules/isolation_rules/Level4/workflow-level4.mdc
```

## Workflow

Step 1: **Read Task Context**
   - Read `memory-bank/tasks.md` to get complexity level
   - Read `memory-bank/activeContext.md` for current context

Step 2: **GitNexus Architecture Scan (replaces broad codebase scan)**
- Call MCP tool: `list_repos`
- IF unavailable → skip to Step 3, log: "gitnexus_unavailable", proceed with manual scan.
- IF available:

  - 2a. Symbol discovery (replaces Step 3's manual file hunting)
     - Call: `query({query: "<task description keywords>"})`
     - Extract: relevant symbols + file locations → use as files_to_modify draft
  
  - 2b. Dependency mapping (L3-4 only)
      - For each primary symbol from 2a:
        - Call: `context({name: "<symbol>"})`
        - Extract:
                   - incoming.calls → blast_radius candidates
                   - outgoing.calls → files that must be understood
  
  - 2c. Pre-plan impact check (L3-4 only)
    - Call: `impact({target: "<primary_symbol>", direction: "upstream", minConfidence: 0.8})`
    - IF Depth 1 non-empty → add to tasks.md as blast_radius
    - IF blast_radius > 5 symbols → upgrade complexity_level by 1

  DO NOT open any file not returned by query results.

Step 3: **Create Plan (write directly to tasks.md)**

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

Step 4: **Technology Validation (L3-4 only)**  

Verify dependencies exist. Note conflicts. Max 5 lines in tasks.md.  

## Hard Rules
- Plan lives in tasks.md — no separate plan file  
- creative_required field is mandatory  
- L2 plan must fit in <20 lines in tasks.md  
- Do not read progress.md at plan phase — not written yet  
- files_to_modify must come from GitNexus query when available — manual listing is fallback only.  


## Usage

Type `/plan` to start planning based on the task in `memory-bank/tasks.md`.

## Next Steps
- creative_required: true → /creative
- creative_required: false → /build


