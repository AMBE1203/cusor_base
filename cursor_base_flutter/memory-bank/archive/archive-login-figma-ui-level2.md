# TASK ARCHIVE: Login screen — Figma UI + follow-up pickers

## METADATA

| Field | Value |
|--------|--------|
| **Task ID** | `login-figma-ui-level2` |
| **Complexity** | Level 2 |
| **Archived** | 2026-04-07 |
| **Reflection** | `memory-bank/reflection/reflection-login-figma-ui-level2.md` |
| **Creative docs** | None |
| **Figma** | Node `675:1044`, file `Ix4ugAIRCsMLByr0UkOeab` ([design copy](https://www.figma.com/design/Ix4ugAIRCsMLByr0UkOeab/C%E1%BB%95ng-gi%E1%BA%A3ng-vi%C3%AAn--Copy-?node-id=675-1044)) |

## SUMMARY

Delivered **Unisoft-style login** matching Figma: gradient header, logo card, bordered form card, shadowed fields, primary **Đăng Nhập**, **Quên mật khẩu** → **`ForgotPasswordPage`** stub. Added **demo** school and role **bottom-sheet** pickers (`login_school_field`, `login_role_field`) with **`Semantics`**, **`mounted`** guards, and role hint **Chọn vai trò**. **`LoginBloc`**, password/biometric flow, **`CounterPage`** navigation on success, and existing login **widget keys** were preserved. School/role are **not** sent to the backend in this slice.

## REQUIREMENTS

1. Visual parity with Figma login frame `675:1044`.
2. Keep **`LoginBloc`** + **`SignInWithPasswordUseCase`**; no break of existing test keys for email/password/submit/error/biometric.
3. Selectable **Chọn trường** and role row (demo data acceptable).
4. **Quên mật khẩu** navigates to a minimal in-app page (stub OK).
5. **`fvm flutter analyze`** and **`fvm flutter test`** pass.

**Deferred (optional):** Exported logo **`Image.asset`**; wiring school/role into **`SignInWithPasswordParams`** when API exists.

## IMPLEMENTATION

| Layer | Changes |
|--------|---------|
| **Presentation** | **`login_page.dart`** — layout widgets (`_GradientHeader`, `_LogoCard`, `_FormCard`, `_PickerRow`, `_ShadowFieldContainer` + optional **`InkWell`**), local state for school/role, bottom sheets, forgot-password navigation |
| **Presentation** | **`forgot_password_page.dart`** (new) — stub **`Scaffold`** + copy |
| **Domain / data** | Unchanged for this slice (credentials-only auth) |

**Tooling note:** Flutter Cursor MCP in this workspace had **no** `implement-flutter-feature` descriptors; work was editor/agent-driven; review via **`flutter-code-reviewer`** subagent; security pass manual + pattern scan on auth presentation.

## TESTING

- `fvm flutter analyze` — no issues (as of archive date)  
- `fvm flutter test` — all tests passed; **`login_bloc_test`** unchanged contract (pickers are UI-only)

## LESSONS LEARNED

Summarized in **`reflection-login-figma-ui-level2.md`**: validate Figma MCP **file access** early; document **plugin/MCP gaps** vs strict `/build`; guard **`setState`** after async sheets; call out **UI-vs-auth** mismatch for pickers until API wiring.

## REFERENCES

- Reflection: `memory-bank/reflection/reflection-login-figma-ui-level2.md`  
- Related (earlier auth architecture): `memory-bank/reflection/reflection-login-auth-level3.md`  
- Code (head): `lib/features/auth/presentation/login_page.dart`, `lib/features/auth/presentation/forgot_password_page.dart`
