# Reflection: Remove biometric login (keep Figma UI)

**Task ID:** `remove-biometric-login-level2`  
**Complexity:** Level 2  
**Date:** 2026-04-07  

## Enhancement Summary

We removed the **biometric sign-in** path end-to-end while keeping the **Figma-aligned** login UI intact. This included deleting biometric gateway + use cases, simplifying `LoginBloc` to **password-only**, removing the fingerprint button from `LoginPage`, removing the `local_auth` dependency, and cleaning up native permission strings (`NSFaceIDUsageDescription`, `USE_BIOMETRIC`). The password login flow and navigation behavior stayed the same, and the test suite remained green.

## What Went Well

- The removal was **surgical and layered**: presentation → bloc → domain → data → DI → native configs → tests.
- Keeping the Figma UI meant **no re-design churn** while removing biometric behavior.
- Verification was straightforward: `fvm flutter pub get`, `fvm flutter analyze`, `fvm flutter test` all passed after the refactor.

## Challenges Encountered

- Biometric concerns touched multiple surfaces (bloc events/state, repository contract, DI, native manifests), so missing one would break builds.
- Some Memory Bank documents and older archives mention biometrics; they’re historical but can be confusing if not clearly marked as “removed”.

## Solutions Applied

- Removed biometric concepts at the **API boundary** (`AuthRepository`) to prevent accidental reintroduction via stale calls.
- Deleted unused biometric files and updated DI registrations to keep the graph minimal.
- Removed native permission strings to avoid unnecessary privacy prompts / review questions.

## Key Technical Insights

- For feature removals, deleting the API surface (`AuthRepository.signInWithBiometric` + related types) is safer than leaving dead code paths.
- When removing platform features, remember to clean both **Dart deps** and **native permissions**.

## Process Insights

- “Remove a feature” is still a Level 2 change when it spans multiple layers; having a checklist in `tasks.md` avoids omissions.
- Always record **evidence** (commands + green status) in Memory Bank to keep the change trustworthy.

## Action Items for Future Work

- If biometrics is needed again, reintroduce it behind a feature flag and update the product requirements first (to avoid flip-flopping).
- Consider updating documentation pages that still mention biometrics as “historical” to reduce confusion.

## Time Estimation Accuracy

- Estimated time: Small (1–2 hours)  
- Actual time: Small (completed same session)  
- Variance: Low  
- Reason: Codebase already had clear layering, making removal deterministic.

