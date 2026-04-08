import 'package:bloc/bloc.dart';

import 'base_event.dart';
import 'base_state.dart';

export 'base_event.dart';
export 'base_state.dart';

abstract class BaseBloc<Event extends BaseEvent, State extends BaseState>
    extends Bloc<Event, State> {
  BaseBloc(super.initialState);
}

/// Convenience base for blocs whose states extend [BaseViewState].
abstract class BaseViewBloc<Event extends BaseEvent, State extends BaseViewState>
    extends BaseBloc<Event, State> {
  BaseViewBloc(super.initialState);
}
