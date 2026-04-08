# TASK ARCHIVE: Remove biometric login (keep Figma UI)

## METADATA

| Field | Value |
|--------|--------|
| **Task ID** | `remove-biometric-login-level2` |
| **Complexity** | Level 2 |
| **Archived** | 2026-04-07 |
| **Reflection** | `memory-bank/reflection/reflection-remove-biometric-login-level2.md` |
| **Creative docs** | None |

## SUMMARY

Removed **biometric sign-in** across presentation, bloc, domain, data, DI, and native config while preserving the **Figma-aligned** login screen layout and **password + forgot-password** flow. Dropped the **`local_auth`** dependency and Android **`USE_BIOMETRIC`** / iOS **`NSFaceIDUsageDescription`** entries.

## REQUIREMENTS

1. Remove biometric login from **`LoginPage`** and **`LoginBloc`** (no fingerprint UI or events).
2. Simplify **`AuthRepository`** to password + **`signOut`** only (no biometric methods or capabilities type at this boundary).
3. Remove **`local_auth`** and related gateway/use-case files.
4. Keep login UI consistent with the existing Figma-style implementation.
5. **`fvm flutter analyze`** and **`fvm flutter test`** pass.

## IMPLEMENTATION

| Area | Changes |
|------|---------|
| **Presentation** | `login_page.dart` — password-only `LoginBloc`; removed biometric constructor deps and biometric button |
| **Bloc** | `login_bloc.dart`, `login_event.dart`, `login_state.dart` — removed `LoginStarted`, `LoginBiometricRequested`, `biometricAvailable`; password submit path unchanged |
| **Domain** | `auth_repository.dart` — biometric APIs removed; `auth_failure.dart` — biometric failure types removed |
| **Data** | `auth_repository_impl.dart` — no `BiometricAuthGateway`; **deleted** `biometric_auth_gateway.dart` |
| **Use cases** | **Deleted** `load_biometric_capabilities_use_case.dart`, `sign_in_with_biometric_use_case.dart` |
| **DI** | `service_locator.dart` — removed gateway + biometric use-case registrations; `AuthRepositoryImpl()` default ctor |
| **Dependencies** | `pubspec.yaml` — removed `local_auth` |
| **Native** | `AndroidManifest.xml` — removed `USE_BIOMETRIC`; `Info.plist` — removed `NSFaceIDUsageDescription` |
| **Tests** | `login_bloc_test.dart`, `auth_use_cases_test.dart` — removed biometric cases |

## TESTING

- `fvm flutter pub get`
- `fvm flutter analyze` — no issues (as of archive date)
- `fvm flutter test` — all tests passed

## LESSONS LEARNED

See **`reflection-remove-biometric-login-level2.md`**: remove features at the **repository API** to avoid dead paths; clean **Dart + native** together when dropping platform auth.

## REFERENCES

- Reflection: `memory-bank/reflection/reflection-remove-biometric-login-level2.md`
- Prior login UI archive: `memory-bank/archive/archive-login-figma-ui-level2.md`
- Historical (with biometrics): `memory-bank/reflection/reflection-login-auth-level3.md`
