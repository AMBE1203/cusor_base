# Reflection: Login screen — Figma UI + follow-up pickers

**Task ID:** `login-figma-ui-level2`  
**Complexity:** Level 2  
**Date:** 2026-04-07  

## Summary

We implemented **high-fidelity login** from Figma node **`675:1044`** (file **`Ix4ugAIRCsMLByr0UkOeab`**), then a **BUILD slice**: demo **school** and **role** bottom-sheet pickers (`login_school_field`, `login_role_field`), **`ForgotPasswordPage`** stub, **`mounted`** guards after sheets, **`Semantics`** on picker rows, and role placeholder copy **Chọn vai trò**. **`LoginBloc`**, **`SignInWithPasswordUseCase`**, success navigation to **`CounterPage`**, and existing credential/biometric **keys** were preserved. Original Figma file copy was **inaccessible** until the user shared a **duplicate file**; MCP **`get_design_context`** then supplied layout reference.

Verification: **`fvm flutter analyze`** (no issues), **`fvm flutter test`** (all tests passed). No `memory-bank/creative/` artifacts; product ambiguity on school/role in auth was handled with **UI-only** state.

## What went well

- **Incremental scope:** Figma layout first, then planned follow-ups (pickers + forgot password) matched **`tasks.md`**.
- **Bloc stability:** Avoided bloating **`LoginBloc`** while the API contract for tenant/role is undefined; demo selections stay in **`_LoginScaffoldState`**.
- **Review loop:** **`flutter-code-reviewer`** surfaced product risk (ignored pickers), **`mounted`**, a11y, and hint copy — most items fixed same day.
- **Accessibility:** **`Semantics(button: true, …)`** on pickers improves screen reader behavior without swapping to **`DropdownButtonFormField`**.

## Challenges

- **Figma permissions:** First **`fileKey`** could not be read via MCP until access/copy issue was resolved — worth validating **share + authenticated email** early.
- **`/build` plugin-only rule vs tooling:** **`plugin-flutter-cursor-plugin-dart`** in this workspace’s MCP folder carried **no** tool descriptors for **`implement-flutter-feature`**; deliverable still required direct edits while documenting the gap in **`tasks.md`**.
- **Product truthfulness:** Pickers can **look** required but are **not** sent on sign-in — acceptable for demo, misleading if shipped without API wiring or copy (“optional” / validation).

## Lessons learned

- **Design-to-code:** Pull **screenshot + spec** via **`get_design_context`**, then implement in Flutter widgets; remote Figma asset URLs are **short-lived** (~7 days) — prefer **exported assets** for production logos.
- **Bottom sheets:** Always guard **`setState`** with **`mounted`** after **`await showModalBottomSheet`**.
- **Level 2 still benefits from PLAN:** Checklist in **`tasks.md`** prevented scope creep into full IAM.

## Process improvements

- For Figma-driven work, add a **pre-flight “MCP can read file”** step (or **`whoami` + test node**) before PROMISING parity dates.
- When **`/build`** mandates plugin commands, **define fallback** (e.g. “allowed if MCP tool list empty”) so agents do not deadlock.

## Technical improvements (follow-ups)

- Wire **`schoolId` / role** into **`SignInWithPasswordParams`** (or dedicated use case) when the backend is specified; add bloc validation + tests.
- Replace hand-drawn logo tiles with **`Image.asset`** from design export if brand requires exact geometry.
- **`ForgotPasswordPage`:** replace stub with reset flow (**`url_launcher`** or API-driven reset) per security/product.
- Optional: **widget/golden tests** for login layout; **scrollable** bottom sheet (`ListView`) when school list grows.

## Next steps

- Run **`/archive`** if the team files completed Level 2 work into **`memory-bank/archive/`** and clears **`tasks.md`** for the next task.
- Coordinate with backend on **tenant context** (school) so UI selections are not cosmetic.
