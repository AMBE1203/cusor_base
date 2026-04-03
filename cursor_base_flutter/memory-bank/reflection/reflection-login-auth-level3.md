# Reflection: Login (clean architecture + Bloc + biometrics)

**Task ID:** `login-auth-level3`  
**Complexity:** Level 3  
**Date:** 2026-04-03  

## Summary

We delivered a login feature with email/password validation, `LoginBloc` state management, a layered `domain` / `data` / `presentation` structure, and biometric sign-in via `local_auth` with Android and iOS permissions. Post-login navigation reuses the existing `CounterPage` as a home shell. The plan in `memory-bank/tasks.md` was followed with minor naming differences (single `LoginState` + `LoginFormStatus` instead of multiple named “initial/success” state classes). No `/creative` artifacts were produced; UI uses default Material 3 patterns.

## What went well

- **Plan-to-code alignment:** Layers and file layout matched the PLAN document; integration via `main.dart` / `ExampleApp` stayed consistent with the existing counter feature’s explicit dependency injection.
- **Testability:** `BiometricAuthGateway` isolates `LocalAuthentication`, and `LoginBloc` tests mock `AuthRepository` without platform channels.
- **Technology validation early:** Dependencies were resolved in PLAN/BUILD before large refactors, reducing integration surprise.
- **Analyzer cleanliness:** `local_auth` 3.x API nuance (`canCheckBiometrics` as a getter returning `Future<bool>`) was caught and fixed quickly once analyzer flagged it.
- **Counter test isolation:** Widget tests now target `CounterPage` directly, avoiding the full auth stack when testing the counter.

## Challenges

- **Async ordering in bloc tests:** `LoginStarted` runs asynchronously; combined with rapid follow-up events it could reorder emissions. Tests that only exercise password flow omit `LoginStarted` to keep expectations deterministic; biometric coverage still uses `LoginStarted` + `wait`.
- **Demo vs production semantics:** Stub credentials and “biometric success = logged in” are correct for a template but must be replaced for real auth (tokens, secure storage, backend).
- **Creative phase skipped:** Branding, accessibility passes, and copy were not formally designed; acceptable for scaffold work but worth revisiting before a user-facing release.

## Lessons learned

- **Read plugin APIs literally:** Not every `Future`-returning member on platform facades is a method; mixing getters and methods is common in federated plugins.
- **Bloc + forms:** Keeping `TextEditingController` in the widget while syncing credentials through events works for MVP; larger forms may benefit from `Form` + `FormField` or unified state in the bloc to avoid drift edge cases.
- **Level 3 benefits from PLAN:** The checklist and layer map reduced scope creep (e.g. not pulling in secure storage prematurely).

## Process improvements

- For features with async init events, standardize on **either** `blocTest` `wait` + ordered `expect` **or** separate tests per concern (init vs submit), documented in the task file.
- When skipping `/creative`, add a one-line **“UI debt”** bullet in `tasks.md` so polish is not forgotten.

## Technical improvements (follow-ups)

- Replace `AuthRepositoryImpl` stub with real API + error mapping; add `flutter_secure_storage` (or equivalent) if sessions persist.
- Introduce a proper **router** (`go_router` / `Navigator 2.0`) and auth-guarded routes instead of imperative `pushReplacement` only.
- Add **widget tests** for `LoginPage` (keys already exist for fields and buttons).
- Consider **equatable** on failure types if they become part of state; currently errors are strings on `LoginState`.
- Harden **email validation** (regex or `package:email_validator`) if product requires stricter rules.

## Next steps

- Run **`/archive`** to fold this task into `memory-bank/archive/` and clear or reset `tasks.md` per team convention.
- Prioritize follow-ups from “Technical improvements” based on product roadmap.
