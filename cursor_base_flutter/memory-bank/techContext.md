# Tech Context

## Stack

- Flutter (stable, FVM-managed per `.fvmrc`)
- Dart SDK per `pubspec.yaml` `environment.sdk`
- **Auth / login (planned):** `flutter_bloc`, `bloc`, `equatable`, `local_auth`; tests: `bloc_test`, `mocktail`

## Validation (local)

- `fvm flutter pub get`
- `fvm flutter analyze`
- `fvm flutter test` (when tests exist)

## IDE / AI

- Cursor isolation rules under `.cursor/rules/isolation_rules/`.
- Commands: `/van`, `/plan`, `/build`, etc.
