# Progress

## Current state

- **Base Bloc / Page (core):** Added `BaseEvent`, `BaseState`, `BaseBloc`, `BaseBlocPage`; `LoginBloc` / `LoginPage` use them. Analyze + tests green (2026-04-07).
- **Base Bloc / Page (ARCHIVE):** `memory-bank/archive/archive-base-bloc-primitives-level3.md` (2026-04-07).
- **Base view state (core):** Added `ViewStatus` + `BaseViewState` and migrated login to use them. Analyze + tests green (2026-04-07).
- **Base view state (REFLECT):** `memory-bank/reflection/reflection-base-view-state-level3.md` added (2026-04-07).
- **Base view state (ARCHIVE):** `memory-bank/archive/archive-base-view-state-level3.md` (2026-04-07).
- **Login (no biometric):** Removed biometric sign-in (`local_auth`, gateway, use cases, bloc events/state, UI button); password flow + Figma UI unchanged. Native Face ID / `USE_BIOMETRIC` entries removed. Analyze + tests green (2026-04-07).
- **Remove biometric (REFLECT):** `memory-bank/reflection/reflection-remove-biometric-login-level2.md` added (2026-04-07).
- **Remove biometric (ARCHIVE):** `memory-bank/archive/archive-remove-biometric-login-level2.md`; `tasks.md` cleared for next task (2026-04-07).
- **Login UI (Figma parity):** `login_page.dart` restyled to match Figma node `675:1044` (file `Ix4ugAIRCsMLByr0UkOeab`). `fvm flutter analyze` and `fvm flutter test` green (2026-04-07).
- **Login follow-up (BUILD):** Demo school/role bottom sheets, `ForgotPasswordPage` stub, a11y `Semantics` on pickers, `mounted` guards after sheets. Analyze + tests green (2026-04-07).
- **Login Figma UI (REFLECT):** `memory-bank/reflection/reflection-login-figma-ui-level2.md` added (2026-04-07).
- **Login Figma UI (ARCHIVE):** `memory-bank/archive/archive-login-figma-ui-level2.md`; `tasks.md` cleared for next task (2026-04-07).
- **ARCHIVE complete (new task):** Dio API base layer finalized.
- Verification for archived task remained green: `fvm flutter analyze` and `fvm flutter test` passed.
- Previous archive remains complete and verified green.
- Previous archive remains complete and verified green.
- **Logout (Level 2)** archived: `memory-bank/archive/archive-logout-level2.md`.

## Recently completed

- Added Dio networking base layer and unit tests (mapper + api client).
- Added reflection document: `memory-bank/reflection/reflection-dio-network-base-classes-level3.md`.
- Added archive document: `memory-bank/archive/archive-dio-network-base-classes-level3.md`.
- Added reflection document: `memory-bank/reflection/reflection-base-use-case-error-handling-level3.md`.
- Added archive document: `memory-bank/archive/archive-base-use-case-error-handling-level3.md`.
- Added shared core primitives (`Failure`, `UseCaseResult`, `BaseUseCase`, `NoParams`).
- Migrated auth/counter use-cases and updated `LoginBloc` flow to use result-based error handling.
- Updated domain and bloc tests for new use-case call contracts.
- Added `get_it` dependency and service locator setup (`setupDependencies` / reset helper).
- Restored and wired auth/counter use-cases through bloc/controller/pages.
- Added and updated domain/bloc tests for the new dependency boundaries.
- Added reflection document: `memory-bank/reflection/reflection-use-cases-get-it-level3.md`.
- Added archive document: `memory-bank/archive/archive-use-cases-get-it-level3.md`.
- Logout: BUILD → REFLECT → ARCHIVE (2026-04-03).
- Login (Level 3) remains documented in `reflection/reflection-login-auth-level3.md` (optional archive).

## Blockers

- (none)
