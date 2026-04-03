# TASK ARCHIVE: Logout screen

## METADATA

| Field | Value |
|--------|--------|
| **Task ID** | `logout-level2` |
| **Complexity** | Level 2 |
| **Archived** | 2026-04-03 |
| **Reflection** | `memory-bank/reflection/reflection-logout-level2.md` |
| **Creative docs** | None |

## SUMMARY

Added a dedicated **logout confirmation** flow after login: **`AuthRepository.signOut()`**, **`LogoutPage`** (cancel / confirm), **`CounterPage`** AppBar entry, and stack reset to **`LoginPage`** via **`pushAndRemoveUntil`**. No new dependencies. Widget tests validate **`signOut`** on confirm and no **`signOut`** on cancel.

## REQUIREMENTS

1. Logout **screen** (not snackbar-only) with cancel and confirm.
2. Entry from **`CounterPage`** (e.g. AppBar **Sign out**).
3. Confirm → **`signOut()`** → clear stack → **`LoginPage`** with same repo instances.
4. Cancel → **pop** without signing out.
5. Tests with mocked **`AuthRepository`**.

## IMPLEMENTATION

| Layer | Changes |
|--------|---------|
| **Domain** | `auth_repository.dart` — `Future<void> signOut()` |
| **Data** | `auth_repository_impl.dart` — no-op **`signOut`** (comment for future tokens/storage) |
| **Presentation** | **`logout_page.dart`** (new); **`login_page.dart`** passes **`authRepository`** to **`CounterPage`**; **`counter_page.dart`** requires **`authRepository`**, pushes **`LogoutPage`** |
| **Tests** | `test/features/auth/logout_page_test.dart`; **`counter_page_test.dart`** — **`_NoopAuthRepository`** |

**Plugin workflow (BUILD):** Followed **`build-flutter-features` SKILL**; evidence in pre-archive **`tasks.md`**.

## TESTING

- `fvm flutter analyze` — no issues  
- `fvm flutter test` — 8 tests passed (login bloc + logout + counter)

## LESSONS LEARNED

- See **`reflection-logout-level2.md`**: domain **`signOut`** keeps logout testable; **`pushAndRemoveUntil`** avoids duplicate login routes; widget tests avoid ambiguous **`Sign in`** text by matching demo hint string.

## REFERENCES

- Reflection: `memory-bank/reflection/reflection-logout-level2.md`  
- Related product work (earlier): `memory-bank/reflection/reflection-login-auth-level3.md`  
- Code (head): `lib/features/auth/presentation/logout_page.dart`, `lib/features/auth/domain/auth_repository.dart`, `lib/features/counter/presentation/counter_page.dart`
