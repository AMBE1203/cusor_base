# Reflection: Use-case layer + get_it DI (Level 3)

## Summary

This task restored and completed the clean-architecture use-case layer for auth and counter, then introduced `get_it` as the composition mechanism. The codebase moved from direct repository wiring in presentation to use-case boundaries with centralized dependency setup in `main.dart` startup.

## What Went Well

- The refactor stayed aligned with the plan phases (dependency, domain use-cases, DI registry, presentation wiring, validation).
- Dependency boundaries improved: `LoginBloc` and `CounterController` now consume explicit use-cases instead of repositories.
- Startup became simpler and consistent via `setupDependencies()` and a thin `ExampleApp`.
- Test confidence improved by adding unit tests for auth/counter use-cases and updating bloc tests to mock use-case boundaries.
- Final quality gates passed (`fvm flutter analyze`, `fvm flutter test`).

## Challenges

- A DI invocation mismatch in `LogoutPage` caused an analyzer failure (`invocation_of_non_function_expression`) and required a follow-up fix.
- Plugin-only command routing was not discoverable from local MCP metadata, so implementation proceeded directly in code to unblock build completion.
- Service-locator usage can hide dependency flow in UI classes unless constructors retain explicit override paths.

## Lessons Learned

- `get_it` setup should always include an explicit test reset path early (`resetDependenciesForTest`) even if not immediately used by all tests.
- Migration tasks are safer when applying one boundary at a time (domain → DI → presentation → tests) with analyzer/test gates after each major slice.
- Constructor overrides remain valuable in a locator-based architecture to preserve testability and readability.

## Process Improvements

- Add a small pre-build checklist for DI migrations:
  - registration map drafted,
  - startup init point defined,
  - test reset strategy defined.
- Standardize reflection naming with feature + architecture scope (as done here) for easier archive lookups.

## Technical Improvements

- Consider adding a lightweight `DependencyOverrides` pattern for widget tests to reduce reliance on global locator state.
- Add focused widget tests for `LoginPage`/`LogoutPage`/`CounterPage` navigation paths under DI to catch wiring regressions earlier.
- Optionally group auth login use-cases in a single immutable dependency object if constructor verbosity grows.

## Next Steps

- Run `/archive` to finalize this task in `memory-bank/archive/`.
- If continuing feature work, establish a default DI/testing template for future modules to keep boundaries consistent.

