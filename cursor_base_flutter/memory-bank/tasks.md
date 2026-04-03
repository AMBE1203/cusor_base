# Tasks

## Current task: Use cases (clean architecture)

- **Complexity:** **Level 3**
- **Status:** **PLAN complete** — next: **`/build`** (optional **`/creative`**: none flagged).

---

### Refined requirements

1. **Domain layer** exposes **use case** classes that depend only on **`AuthRepository`** / **`CounterRepository`** (interfaces), never on Flutter.
2. **Presentation** (`LoginBloc`, `CounterController`, `LogoutPage`) depends on **use cases**, not repositories.
3. **Composition root** (`main.dart` / `ExampleApp`) constructs repositories once, then use cases, then passes use cases into widgets/blocs.
4. **Tests:** unit tests for use cases with mocked repositories; bloc/widget tests mock **use cases** (or repositories only if testing use case internals separately — prefer mocking use cases at bloc boundary).

### Scope decision

| Feature | In scope |
|---------|----------|
| **Auth** | **Yes** — four use cases (see below). |
| **Counter** | **Yes** — two use cases for parity with clean architecture; keeps `CounterController` thin. |

---

### Use case catalog

**Auth** (`lib/features/auth/domain/use_cases/`)

| Class | Responsibility | Delegates to |
|-------|----------------|--------------|
| `LoadBiometricCapabilitiesUseCase` | Single `call()` returning `Future<BiometricCapabilities>` | `AuthRepository.loadBiometricCapabilities` |
| `SignInWithPasswordUseCase` | `call({required String email, required String password})` | `AuthRepository.signInWithPassword` |
| `SignInWithBiometricUseCase` | `call()` | `AuthRepository.signInWithBiometric` |
| `SignOutUseCase` | `call()` | `AuthRepository.signOut` |

**Counter** (`lib/features/counter/domain/use_cases/`)

| Class | Responsibility | Delegates to |
|-------|----------------|--------------|
| `GetCurrentCountUseCase` | `call()` → `Future<int>` | `CounterRepository.current` |
| `IncrementCounterUseCase` | `call()` → `Future<int>` (return new value for convenience) | `CounterRepository.increment` |

*Note:* `IncrementCounterUseCase` can return `Future<void>` if you prefer mirroring the repository exactly; returning `int` avoids an extra `current()` read in the controller — **BUILD** can pick one and stay consistent.

---

### File map (new + modified)

**New files**

- `lib/features/auth/domain/use_cases/load_biometric_capabilities_use_case.dart`
- `lib/features/auth/domain/use_cases/sign_in_with_password_use_case.dart`
- `lib/features/auth/domain/use_cases/sign_in_with_biometric_use_case.dart`
- `lib/features/auth/domain/use_cases/sign_out_use_case.dart`
- `lib/features/counter/domain/use_cases/get_current_count_use_case.dart`
- `lib/features/counter/domain/use_cases/increment_counter_use_case.dart`

**Modified**

- `lib/features/auth/presentation/bloc/login_bloc.dart` — inject the three login-related use cases (not `AuthRepository`).
- `lib/features/auth/presentation/login_page.dart` — `BlocProvider` / `LoginPage` constructors take use cases; still pass **`CounterRepository`** for navigation to `CounterPage` (or pass a `HomeFactory` — keep simple: repos for pages that need them).
- `lib/features/auth/presentation/logout_page.dart` — `SignOutUseCase` + **`CounterRepository`** (for rebuilding `LoginPage` with same deps).
- `lib/features/counter/presentation/counter_controller.dart` — `GetCurrentCountUseCase`, `IncrementCounterUseCase`.
- `lib/features/counter/presentation/counter_page.dart` — accept use cases **or** accept controller only if controller is constructed above — **plan:** `CounterPage` receives the two use cases and builds `CounterController` internally **or** `main` builds `CounterController` with use cases. Simplest: **`CounterPage(counterRepository)` replaced by** `CounterPage(getCount: ..., increment: ...)` **or** keep **`CounterController({ required GetCurrentCountUseCase get, required IncrementCounterUseCase inc })`** constructed in `CounterPage.initState` from passed use cases.
- `lib/app/app.dart` / `lib/main.dart` — construct all use cases; thread into `ExampleApp` / `LoginPage` / `CounterPage` as needed.

---

### Implementation phases (BUILD order)

1. **Auth use cases** — implement four classes + **unit tests** (`test/features/auth/domain/...` or `test/.../use_cases/`).
2. **Counter use cases** — implement two classes + unit tests.
3. **Wire `LoginBloc`** — replace `AuthRepository` with three use cases; adjust **`login_bloc_test.dart`** (mock use cases with `mocktail`).
4. **Wire `LogoutPage` + `LoginPage`** — DI for `SignOutUseCase` and bloc use cases.
5. **Wire `CounterController` + `CounterPage` + `login_page` navigation** — pass use cases into counter flow.
6. **`main.dart` / `ExampleApp`** — single composition root.
7. **Full** `fvm flutter analyze` **+** `fvm flutter test`; fix integration tests (`logout_page_test`, `counter_page_test`).

---

### Technology validation

- **No new `pub` dependencies.**
- Proof: `flutter pub get` already resolves; use cases are pure Dart.

---

### Challenges & mitigations

| Challenge | Mitigation |
|-----------|------------|
| Bloated `LoginBloc` constructor (3 deps) | Acceptable for Level 3; optional future: `LoginInteractor` facade **only if** team agrees (not in this plan). |
| `ExampleApp` / `LoginPage` parameter lists | Group auth use cases in a small immutable `AuthLoginActions` holder **optional** — only if constructor noise hurts readability. |
| Counter repository still needed for `LoginPage`→`CounterPage` | Keep passing **`CounterRepository`** alongside use cases for navigation data; no violation. |

---

### Creative phases

- **None** — internal refactor; UI unchanged.

---

### Planning checklist

- [x] VAN / complexity (Level 3)
- [x] PLAN — use case list, files, phases, counter in scope
- [ ] BUILD
- [ ] Tests green
- [ ] REFLECT / ARCHIVE as needed

---

## Last archived

| When | Task | Archive |
|------|------|---------|
| 2026-04-03 | Logout screen (Level 2) | `memory-bank/archive/archive-logout-level2.md` |

## Historical (related)

- Login (Level 3) — `memory-bank/reflection/reflection-login-auth-level3.md`
