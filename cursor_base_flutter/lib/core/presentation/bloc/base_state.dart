import 'package:equatable/equatable.dart';

/// Root type for feature [Bloc] states ([Equatable] for diff-friendly tests).
abstract class BaseState extends Equatable {
  const BaseState();
}

/// Shared view status for screens that follow a simple request lifecycle.
enum ViewStatus { initial, loading, success, failure }

/// A reusable base state for screens that share loading/error/success semantics.
///
/// Feature states can extend this to avoid redefining `status` + `errorMessage`.
abstract class BaseViewState extends BaseState {
  const BaseViewState({
    this.status = ViewStatus.initial,
    this.errorMessage,
  });

  final ViewStatus status;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, errorMessage];
}
