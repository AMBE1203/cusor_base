# Reflection: Base view state (shared loading/error/success)

**Task ID:** `base-view-state-level3`  
**Complexity:** Level 3  
**Date:** 2026-04-07  

## Brief feature summary

We evolved the base presentation primitives to support multiple screens sharing a consistent request lifecycle: **initial → loading → success/failure**, plus a standard **error message** field. Concretely:

- Added `ViewStatus` and `BaseViewState(status, errorMessage)` to `lib/core/presentation/bloc/base_state.dart`
- Added `BaseViewBloc` as a convenience base for blocs using `BaseViewState`
- Migrated login (`LoginState`, `LoginBloc`, `LoginPage`, tests) away from feature-specific status enums to the shared model.

## 1) Overall outcome & requirements alignment

- **Met requirements:** A reusable status model now exists and is adopted by at least one real screen (login).
- **No regressions:** Analyzer and test suite stayed green after migration.
- **Scope contained:** We only changed the status/error portion; feature-specific state (`email`, `password`) remains in `LoginState`.

## 2) Planning phase review

- The change was small but cross-cutting; having a single adopter (login) made it safe to implement without a large plan.
- A quick pass over impacted files (bloc, UI, tests) was enough to avoid stranding references to the old enum.

## 3) Creative phase(s) review

- Not applicable.

## 4) Implementation phase review

### What went well
- `BaseViewState` reduced repeated boilerplate and makes new screens consistent by default.
- Login migration was straightforward: replace `LoginFormStatus` with `ViewStatus` and inherit shared `props`.

### Challenges
- `ViewStatus` lives in a core file; consumers must import it consistently. The simplest path is to re-export it through the feature bloc barrel (as done for login) or through a single “presentation” import pattern.

## 5) Testing phase review

- Existing `LoginBloc` tests were sufficient to validate the refactor; they now assert `ViewStatus.loading/success/failure`.

## 6) What went well (highlights)

- Shared model introduced with a real adopter immediately.
- Kept feature state clean; only moved generic fields to the base.
- Maintained green validation gates.

## 7) What could have been done differently

- Add a short usage snippet for new feature states: “extend `BaseViewState`, then add feature fields + include `...super.props` in `props`.”
- Consider a single export entrypoint (e.g. `core/presentation/presentation.dart`) to avoid import scattering as the project grows.

## 8) Key lessons learned

- **Technical:** Shared state primitives work best when they’re minimal and proven by adoption; keep feature-specific fields out of the base.
- **Process:** Cross-cutting refactors should be validated by a full test run even if the change appears mechanical.

## 9) Actionable improvements for future Level 3 features

- When adding a second screen with shared lifecycle, decide whether it should extend `BaseViewState` or define a richer domain-specific state.
- If many screens adopt this, introduce a single canonical import/export to keep usage consistent.

