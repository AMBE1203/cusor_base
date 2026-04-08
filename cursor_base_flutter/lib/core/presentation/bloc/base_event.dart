import 'package:equatable/equatable.dart';

/// Root type for feature [Bloc] events ([Equatable] for diff-friendly tests).
abstract class BaseEvent extends Equatable {
  const BaseEvent();

  @override
  List<Object?> get props => [];
}
