# Reflection: Dio API base classes (Level 3)

## Summary

Added a core networking layer using Dio that is easy to reuse and extend: a `DioFactory` for configuration, an `ApiClient` interface with a `DioApiClient` implementation, a `NetworkErrorMapper` that converts Dio errors into domain-safe `Failure`s, and a small set of `NetworkFailure` types. Wired the layer into `get_it` and validated with unit tests plus full analyze/test runs.

## What Went Well

- Networking code lives in a clear shared location (`lib/core/network/`) and doesn’t leak into UI.
- Error policy is consistent with the existing domain error model (`Failure` / `UnexpectedFailure`).
- DI wiring is straightforward: `Dio` + `ApiClient` are singletons and easy to swap in tests.
- Unit tests cover mapper behavior and basic client response normalization without real network calls.

## Challenges

- Constructor wiring for `BadResponseFailure` required explicit `super(message)` to satisfy Dart’s super-initializer rules.
- Base URL configuration is still a placeholder; real environments/config were intentionally not introduced in this infrastructure-only task.

## Lessons Learned

- Keep the base client minimal (JSON map/list helpers) until a real feature API needs more (multipart, streaming, typed decoding).
- Mapper tests are high ROI because Dio exception shapes can vary; defaulting to `UnexpectedFailure` is a safe fallback.
- Registering `ApiClient` (not `Dio`) as the primary dependency keeps feature repositories decoupled from Dio specifics.

## Process Improvements

- Add a follow-up task template for “wire real baseUrl/env + auth interceptor” so the placeholder doesn’t linger.
- When adding new infrastructure, always include at least one focused unit test per core primitive (mapper + client here worked well).

## Technical Improvements

- Consider adding:
  - an optional request-id/logging interceptor (guarded by build mode)
  - a configurable retry strategy (opt-in per request)
  - a typed decoding helper (e.g. `T fromJson(Map)`), once there’s a concrete API model

## Next Steps

- Add environment/baseUrl configuration (dev/staging/prod) and (optionally) auth header injection.
- Create the first feature remote API client under `lib/features/<feature>/data/remote/` that depends on `ApiClient`.
- Run `/archive` for this task.

