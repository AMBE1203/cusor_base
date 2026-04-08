# TASK ARCHIVE: Base view state (shared loading/error/success)

## METADATA

| Field | Value |
|--------|--------|
| **Task ID** | `base-view-state-level3` |
| **Complexity** | Level 3 |
| **Archived** | 2026-04-07 |
| **Reflection** | `memory-bank/reflection/reflection-base-view-state-level3.md` |
| **Creative docs** | None |

## SUMMARY

Extended the base presentation primitives to support multiple screens sharing a consistent lifecycle model:

- `ViewStatus`: `initial`, `loading`, `success`, `failure`
- `BaseViewState`: common `status` + `errorMessage`
- `BaseViewBloc`: convenience base for blocs using `BaseViewState`

Migrated the login flow to use the shared model by replacing the previous feature-specific status enum with `ViewStatus` in bloc/UI/tests.

## REQUIREMENTS

1. Provide reusable base types to represent **loading/error/success** across screens.
2. Avoid polluting feature states: keep feature fields in feature state classes; only generic fields in the base.
3. Migrate at least one real screen (login) to prove adoption.
4. Keep analyzer + test gates green.

## IMPLEMENTATION

### Core primitives

| Item | Path |
|------|------|
| Status enum | `lib/core/presentation/bloc/base_state.dart` (`ViewStatus`) |
| Base view state | `lib/core/presentation/bloc/base_state.dart` (`BaseViewState`) |
| Base view bloc | `lib/core/presentation/bloc/base_bloc.dart` (`BaseViewBloc`) |

### Adoption (login)

| Area | Files | Notes |
|------|-------|------|
| State | `lib/features/auth/presentation/bloc/login_state.dart` | `LoginState extends BaseViewState` and adds feature fields |
| Bloc | `lib/features/auth/presentation/bloc/login_bloc.dart` | Emits `ViewStatus.*` and maps failures into `errorMessage` |
| UI | `lib/features/auth/presentation/login_page.dart` | Uses `ViewStatus.loading/success` |
| Tests | `test/features/auth/login_bloc_test.dart` | Assertions updated to `ViewStatus.*` |

## TESTING

- `fvm flutter analyze` — no issues (as of archive date)  
- `fvm flutter test` — all tests passed

## LESSONS LEARNED

- Shared primitives should stay **minimal** and be immediately validated by a real adopter.
- As adoption grows, consider a single canonical import/export for presentation primitives to avoid scattered imports.

## REFERENCES

- Reflection: `memory-bank/reflection/reflection-base-view-state-level3.md`
- Prior base primitives archive: `memory-bank/archive/archive-base-bloc-primitives-level3.md`

