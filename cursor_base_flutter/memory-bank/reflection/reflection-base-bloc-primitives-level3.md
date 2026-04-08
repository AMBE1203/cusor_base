# Reflection: Base Bloc/Page/Event/State primitives

**Task ID:** `base-bloc-primitives-level3`  
**Complexity:** Level 3  
**Date:** 2026-04-07  

## Brief feature summary

We introduced reusable presentation-layer primitives to standardize how blocs and bloc-backed pages are authored:

- `BaseEvent` / `BaseState` as `Equatable` roots
- `BaseBloc<E, S>` as the common bloc base
- `BaseBlocPage<B>` as a shared `BlocProvider` wrapper for pages

We migrated the existing auth flow as the first adopter: `LoginBloc` now extends `BaseBloc<LoginEvent, LoginState>`, events/states extend the base types, and `LoginPage` now extends `BaseBlocPage<LoginBloc>`.

## 1) Overall outcome & requirements alignment

- **Met requirements:** Base types created and real code migrated (`LoginBloc`, `LoginPage`).
- **Scope stayed controlled:** Only one feature bloc exists in the repo, so rollout was minimal and low-risk.
- **Success criteria:** `fvm flutter analyze` and `fvm flutter test` were green after migration.

## 2) Planning phase review

- This was a cross-cutting change (Level 3) but in a **small codebase surface** (single bloc), so detailed up-front planning was lightweight.
- Having a clear “first adopter” (login) reduced ambiguity and ensured the abstractions were not theoretical.

## 3) Creative phase(s) review

- Not applicable. No UI/UX design decisions required.

## 4) Implementation phase review

### What went well
- **Low churn adoption:** Login migrated cleanly; tests required no functional behavior change.
- **Consistent equatability:** Centralizing `Equatable` roots reduces boilerplate and keeps tests stable.
- **Compile-time safety:** Type bounds on `BaseBloc<Event extends BaseEvent, State extends BaseState>` make intended usage explicit.

### What was tricky
- Base page abstraction must remain **thin** to avoid constraining features (e.g. multi-bloc pages, nested providers).
- The first iteration used `BlocBase<Object?>` which is intentionally permissive; future adjustments may be needed if pages rely on strongly typed bloc interfaces.

## 5) Testing phase review

- Existing unit/bloc tests were sufficient to validate the migration because behavior remained the same.
- No new tests were introduced for the base primitives (acceptable at this scale); future expansion could add a small widget test for `BaseBlocPage` creation behavior.

## 6) What went well (highlights)

- Minimal abstractions with a real adopter immediately.
- Analyzer + full test suite stayed green.
- Reduced event/state boilerplate in features.

## 7) What could have been done differently

- Consider adding a short doc snippet (in `systemPatterns.md` or style guide) showing “how to create a new Bloc/Page” using these primitives.
- Consider a `BaseBlocPage` variant for multi-provider pages if the project grows.

## 8) Key lessons learned

- **Technical:** Start with a single adopter and keep base primitives intentionally small; avoid premature frameworking.
- **Process:** For Level 3 refactors, success is best measured by **no regressions** and **clear migration path**.

## 9) Actionable improvements for future Level 3 features

- Add a template snippet for new blocs/pages using `BaseBloc` + `BaseBlocPage`.
- If a second bloc is introduced, reassess whether `BaseBlocPage`’s API is still ergonomic (e.g. needing `MultiBlocProvider`).

