# TASK ARCHIVE: Dio API base classes (maintainable + inheritable)

## METADATA

- Task ID: `dio-network-base-classes-level3`
- Date: 2026-04-03
- Complexity: Level 3
- Status: Complete (VAN → PLAN → BUILD → REFLECT → ARCHIVE)

## SUMMARY

Introduced a reusable Dio-based networking foundation: a factory to configure Dio, a small `ApiClient` abstraction with a Dio implementation, a centralized error mapper that converts Dio failures into domain `Failure`s, and a set of `NetworkFailure` types. Wired these dependencies into `get_it` and added unit tests to validate behavior without real network calls.

## REQUIREMENTS

1. Add Dio and create maintainable base classes for calling APIs.
2. Centralize config (timeouts/headers/baseUrl) and cross-cutting hooks (via interceptors).
3. Provide consistent error mapping into the domain `Failure` model.
4. Integrate with `get_it` and remain easy to test.

## IMPLEMENTATION

### Dependency

- Added `dio` to `pubspec.yaml`.

### Core networking layer (new)

- `lib/core/network/network_failure.dart`
  - `NetworkFailure` base
  - `TimeoutFailure`, `NoConnectionFailure`, `CancelledFailure`, `BadResponseFailure(statusCode, message)`
- `lib/core/network/network_error_mapper.dart`
  - `NetworkErrorMapper.map(Object error)` converts `DioException` types to `NetworkFailure` and falls back to `UnexpectedFailure`
- `lib/core/network/dio_factory.dart`
  - `DioFactory.create(baseUrl, interceptors)` configures `BaseOptions` (JSON headers + timeouts)
- `lib/core/network/api_client.dart`
  - `ApiClient` interface (`getJson`, `getJsonList`, `postJson`)
- `lib/core/network/dio_api_client.dart`
  - `DioApiClient` implements `ApiClient` and uses `NetworkErrorMapper` to throw domain `Failure`s

### DI wiring (modified)

- `lib/app/di/service_locator.dart`
  - registers `NetworkErrorMapper`, `DioFactory`, configured `Dio`, and `ApiClient`
  - base URL currently uses a placeholder (`https://example.com`) until env/config is added

## TESTING

- Added unit tests:
  - `test/core/network/network_error_mapper_test.dart`
  - `test/core/network/dio_api_client_test.dart`
- Verification gates:
  - `fvm flutter analyze` passed
  - `fvm flutter test` passed

## LESSONS LEARNED

- Keep base abstractions minimal until a real feature API drives additional needs.
- Mapper tests are high leverage since Dio exception shapes can vary by platform/version.
- Prefer registering `ApiClient` (not `Dio`) as the dependency boundary for feature repositories.

## REFERENCES

- Reflection: `memory-bank/reflection/reflection-dio-network-base-classes-level3.md`
- Related archives:
  - `memory-bank/archive/archive-base-use-case-error-handling-level3.md`
  - `memory-bank/archive/archive-use-cases-get-it-level3.md`

