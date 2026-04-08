# TASK ARCHIVE: Base Bloc/Page/Event/State primitives

## METADATA

| Field | Value |
|--------|--------|
| **Task ID** | `base-bloc-primitives-level3` |
| **Complexity** | Level 3 |
| **Archived** | 2026-04-07 |
| **Reflection** | `memory-bank/reflection/reflection-base-bloc-primitives-level3.md` |
| **Creative docs** | None |

## SUMMARY

Introduced a small set of **core presentation primitives** to standardize BLoC usage across features:

- `BaseEvent` / `BaseState` as shared `Equatable` roots
- `BaseBloc<E, S>` as the common bloc base class
- `BaseBlocPage<B>` as a reusable `BlocProvider` page wrapper (`createBloc` + `buildPage`)

Migrated the existing login flow as the first adopter: `LoginBloc` now extends `BaseBloc<LoginEvent, LoginState>`, events/states extend the base types, and `LoginPage` now extends `BaseBlocPage<LoginBloc>`.

## REQUIREMENTS

1. Provide reusable base types for bloc **event**, **state**, and **bloc**.
2. Provide a reusable base page wrapper for pages that own a bloc instance.
3. Migrate existing feature code (login) to use the new base types.
4. Keep analyzer and test gates green.

## IMPLEMENTATION

### New core files

| Item | Path |
|------|------|
| Base event | `lib/core/presentation/bloc/base_event.dart` |
| Base state | `lib/core/presentation/bloc/base_state.dart` |
| Base bloc | `lib/core/presentation/bloc/base_bloc.dart` |
| Base page | `lib/core/presentation/base_bloc_page.dart` |

### Feature migration (login)

| Area | Files | Notes |
|------|-------|------|
| Bloc base | `lib/features/auth/presentation/bloc/login_bloc.dart` | `LoginBloc` extends `BaseBloc<LoginEvent, LoginState>` |
| Event base | `lib/features/auth/presentation/bloc/login_event.dart` | `LoginEvent` extends `BaseEvent` |
| State base | `lib/features/auth/presentation/bloc/login_state.dart` | `LoginState` extends `BaseState` |
| Page base | `lib/features/auth/presentation/login_page.dart` | `LoginPage` extends `BaseBlocPage<LoginBloc>` |

## TESTING

- `fvm flutter analyze` — no issues (as of archive date)  
- `fvm flutter test` — all tests passed

## LESSONS LEARNED

- Keep base primitives **thin** and validate them through a real adopter immediately (login).
- For shared abstractions, success is best measured by **zero regressions** and a **clear migration pattern** for future features.

## REFERENCES

- Reflection: `memory-bank/reflection/reflection-base-bloc-primitives-level3.md`
- Related shared-domain work: `memory-bank/archive/archive-base-use-case-error-handling-level3.md`

