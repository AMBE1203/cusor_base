# TASK ARCHIVE: Use-case layer + get_it injection (clean architecture)

## METADATA

- Task ID: `use-cases-get-it-level3`
- Date: 2026-04-03
- Complexity: Level 3
- Status: Complete (VAN → PLAN → BUILD → REFLECT → ARCHIVE)

## SUMMARY

Implemented a clean-architecture use-case layer for auth and counter features and migrated dependency wiring to `get_it`. Presentation now depends on use-cases, startup initializes DI once, and validation gates passed after migration.

## REQUIREMENTS

1. Keep domain logic in use-cases that depend only on repository interfaces.
2. Move presentation dependencies from repositories to use-cases.
3. Centralize composition root with `get_it` initialized before `runApp`.
4. Keep or improve testability with unit and bloc-level coverage.

## IMPLEMENTATION

- Added `get_it` dependency to `pubspec.yaml`.
- Added use-cases:
  - Auth: load biometric capabilities, sign in with password, sign in with biometric, sign out
  - Counter: get current count, increment counter
- Added DI registry:
  - `lib/app/di/service_locator.dart`
  - `setupDependencies()` for app startup
  - `resetDependenciesForTest()` for test isolation
- Rewired app layers:
  - `main.dart` now initializes DI before app launch
  - `app.dart` simplified to a thin app shell
  - `LoginBloc`, `LoginPage`, `LogoutPage`, `CounterController`, `CounterPage` now consume use-cases
- Updated tests:
  - `test/features/auth/login_bloc_test.dart` now mocks use-cases at bloc boundary
  - Added auth and counter use-case unit tests

## TESTING

- Executed `fvm flutter pub get` successfully.
- Executed `fvm flutter analyze` with no issues.
- Executed `fvm flutter test` with all tests passing.
- One analyzer issue during build (`invocation_of_non_function_expression` in `LogoutPage`) was fixed and re-verified.

## LESSONS LEARNED

- Define DI setup/reset contracts early in migration tasks.
- Apply architecture migrations in slices (domain → DI → presentation → tests) with frequent quality gates.
- Maintain optional constructor overrides where helpful to keep locator-based code testable and explicit.

## REFERENCES

- Reflection: `memory-bank/reflection/reflection-use-cases-get-it-level3.md`
- Archived related task: `memory-bank/archive/archive-logout-level2.md`
- Historical related reflection: `memory-bank/reflection/reflection-login-auth-level3.md`

