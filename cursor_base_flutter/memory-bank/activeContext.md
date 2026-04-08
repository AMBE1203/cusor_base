# Active Context

## Mode

Idle / ready for new task (previous task **archived**).

## Current focus

- **Shared status:** `ViewStatus` + `BaseViewState` for consistent loading/error/success semantics across screens.
- **Adoption:** `LoginState` now extends `BaseViewState`; login flow uses `ViewStatus` in bloc/UI/tests.

## Next

- Start next task with **`/van`**.

## Note

- Current base primitives now include `BaseViewState` + `ViewStatus` for shared loading/error/success semantics.

## Status

- Archived. Ready for next task.
