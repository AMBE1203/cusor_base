# Reflection: Base use-case error handling (Level 3)

## Summary

Introduced a shared domain abstraction (`BaseUseCase`) with a consistent result wrapper (`UseCaseResult`) to centralize error handling. Migrated existing auth and counter use-cases to inherit from the base class, updated consumers (notably `LoginBloc`) to use explicit success/failure branching, and updated tests to match the new contract.

## What Went Well

- Migration stayed within domain boundaries: shared primitives live under `lib/core/domain/` with no Flutter coupling.
- Use-cases now have a single, consistent execution pathway and error policy.
- Consumers became more deterministic by branching on `UseCaseResult` instead of catching exceptions.
- Tests were updated alongside the API change and remained green after the fix in `AuthFailure`.

## Challenges

- Converting `AuthFailure` to inherit `Failure` required adjusting its constructor to forward `message` to `super` (avoiding implicit super init errors).
- Updating mocks in bloc tests required new fallback values (e.g. `SignInWithPasswordParams`) and switching from `thenThrow` to `UseCaseResult.failure(...)`.
- Some consumers (e.g., `LogoutPage`, `CounterController`) needed small call-signature changes (`NoParams`).

## Lessons Learned

- For cross-cutting API changes, updating tests in lockstep with the implementation reduces time spent chasing cascading failures.
- A minimal base API (`call` + `execute`, plus `NoParams`) is sufficient initially; avoid adding layers until needed.
- Result-based handling makes UI/application logic more explicit, but you should standardize the mapping from failure → message in one place where possible.

## Process Improvements

- Add a checklist item for “update mocks + fallback values” whenever use-case signatures change.
- Consider a small “migration guide” section in `memory-bank/tasks.md` when introducing core abstractions that affect many files.

## Technical Improvements

- Consider adding `Result` helpers:
  - `T? get dataOrNull`
  - `Failure? get failureOrNull`
  - `R fold<R>(...)` (only if it improves readability)
- Evaluate whether `UseCaseResult` should carry stack traces for unexpected failures for better debugging (still domain-safe).
- Optionally add a dedicated mapping utility for turning `Failure` into UI messages to keep blocs thin.

## Next Steps

- Run `/archive` to finalize this task.
- If new use-cases are added, enforce inheritance from `BaseUseCase` and the `Params` pattern by convention.

