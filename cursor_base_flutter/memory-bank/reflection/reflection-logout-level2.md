# Reflection: Logout screen

**Task ID:** `logout-level2`  
**Complexity:** Level 2  
**Date:** 2026-04-03  

## Summary

We added a **`LogoutPage`** with cancel/confirm, extended **`AuthRepository`** with **`signOut()`**, wired **`CounterPage`** (AppBar **Sign out**) and **`LoginPage`** (pass **`authRepository`** into home), and reset the stack with **`pushAndRemoveUntil`** back to **`LoginPage`**. No new packages. Widget tests cover confirm (**`signOut`** called + login content) and cancel (no **`signOut`**). No `/creative` documents were produced; confirm uses error-themed **`FilledButton`** per plan.

## What went well

- **Plan adherence:** File checklist in `tasks.md` matched delivery (domain → data → presentation → tests).
- **Compile-time safety:** Requiring **`authRepository`** on **`CounterPage`** avoided silent missing DI.
- **Tests:** `mocktail` verification on **`signOut`** plus **`_NoopAuthRepository`** for the counter widget test kept isolation clean.
- **Navigation:** **`pushAndRemoveUntil`** prevents duplicate **`LoginPage`** instances on the stack after logout.

## Challenges

- **Plugin-only BUILD expectations:** The Cursor **`implement-flutter-feature`** entry is a skill pointer, not a shell tool; validation relied on **`fvm flutter analyze`** / **`test`** when Dart MCP descriptors were absent in `mcps/`.
- **Widget assertion for “back to login”:** Login UI repeats “Sign in” (AppBar + button); tests asserted **`textContaining('demo@example.com')`** instead of a brittle single **`find.text('Sign in')`**.
- **Session model:** **`signOut()`** is a no-op in the demo — correct for scope but easy to forget when adding real tokens later.

## Lessons learned

- For auth flows, **explicit `signOut` on the domain contract** keeps logout testable even before persistence exists.
- **Pushing** `LogoutPage` then **pop** on cancel preserves counter state without extra bloc.

## Process improvements

- When documenting BUILD, keep a **one-line “evidence” block** (analyze + test counts) — already in `tasks.md` for this task.
- If `/build` insists on plugin-only execution, **name the invocable step** (MCP tool ID or script) so agents know when the workflow is **BLOCKED** vs **skill-guided**.

## Technical improvements (follow-ups)

- Implement **`signOut`** for real: clear **`flutter_secure_storage`**, revoke refresh tokens, clear in-memory user.
- Consider **`go_router`** redirect when **unauthenticated** to avoid manual **`pushAndRemoveUntil`** drift.
- Add **`Key`** on **`LoginPage`** root if tests need a single stable finder.

## Next steps

- Run **`/archive`** to file this task and reset `tasks.md` if that is your team norm.
- For production hardening, remove or gate **demo credentials** in UI and **`AuthRepositoryImpl`**.
