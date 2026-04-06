# TASK ARCHIVE: Base use-case class for centralized error handling

## METADATA

- Task ID: `base-use-case-error-handling-level3`
- Date: 2026-04-03
- Complexity: Level 3
- Status: Complete (VAN → PLAN → BUILD → REFLECT → ARCHIVE)

## SUMMARY

Added a shared domain-level use-case abstraction to standardize error handling across features. Introduced a common `Failure` model and a `UseCaseResult<T>` wrapper, migrated existing auth/counter use-cases to inherit from `BaseUseCase`, and updated application logic (notably `LoginBloc`) and tests to use the result-based contract.

## REQUIREMENTS

1. Provide a reusable base use-case class for centralized exception handling.
2. Keep the abstraction domain-safe (no Flutter dependencies).
3. Ensure feature-specific failures (e.g. `AuthFailure`) integrate with the shared failure model.
4. Migrate existing use-cases and adjust consumers/tests accordingly.
5. Maintain green validation gates (analyze + tests).

## IMPLEMENTATION

### Core primitives (new)

- `lib/core/domain/failures/failure.dart`
  - `Failure` base exception type
  - `UnexpectedFailure` for unknown exceptions
- `lib/core/domain/failures/use_case_result.dart`
  - `UseCaseResult<T>` with `success`/`failure` constructors
- `lib/core/domain/use_cases/base_use_case.dart`
  - `NoParams` for parameterless use-cases
  - `BaseUseCase<Output, Params>`:
    - public `call(params)` returns `UseCaseResult<Output>`
    - subclass implements `execute(params)`
    - error policy: `Failure` passes through; others map to `UnexpectedFailure`

### Feature migrations (modified)

- `lib/features/auth/domain/auth_failure.dart`
  - `AuthFailure` now extends shared `Failure` (constructor forwards `message` to `super`)
- Auth use-cases now extend `BaseUseCase`:
  - `LoadBiometricCapabilitiesUseCase` → `BaseUseCase<BiometricCapabilities, NoParams>`
  - `SignInWithPasswordUseCase` → `BaseUseCase<void, SignInWithPasswordParams>`
  - `SignInWithBiometricUseCase` → `BaseUseCase<void, NoParams>`
  - `SignOutUseCase` → `BaseUseCase<void, NoParams>`
- Counter use-cases now extend `BaseUseCase`:
  - `GetCurrentCountUseCase` → `BaseUseCase<int, NoParams>`
  - `IncrementCounterUseCase` → `BaseUseCase<int, NoParams>`

### Consumer updates (modified)

- `lib/features/auth/presentation/bloc/login_bloc.dart`
  - migrated from `try/catch` to explicit `UseCaseResult` branching and a consistent failure→message mapping
- `lib/features/counter/presentation/counter_controller.dart`
  - updated to call use-cases with `NoParams` and use `result.data` when available
- `lib/features/auth/presentation/logout_page.dart`
  - updated to call `SignOutUseCase` with `NoParams`

## TESTING

- Updated tests to the new use-case contract:
  - `test/features/auth/login_bloc_test.dart` (mocks now return `UseCaseResult.*`, added fallback for params)
  - `test/features/auth/domain/auth_use_cases_test.dart` (delegation + unknown-exception wrapping)
  - `test/features/counter/domain/counter_use_cases_test.dart` (delegation via `UseCaseResult`)
- Verification:
  - `fvm flutter analyze` passed
  - `fvm flutter test` passed

## LESSONS LEARNED

- Cross-cutting abstractions are safest when tests are migrated in lockstep with API changes.
- Keep the base use-case API minimal early (`call` + `execute` + `NoParams`); expand only when there is a proven need.
- Standardize the UI mapping from `Failure` to messages to avoid duplicated logic.

## REFERENCES

- Reflection: `memory-bank/reflection/reflection-base-use-case-error-handling-level3.md`
- Related archive: `memory-bank/archive/archive-use-cases-get-it-level3.md`

