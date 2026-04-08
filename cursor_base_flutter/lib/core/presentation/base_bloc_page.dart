import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Wraps [BlocProvider] so feature pages share one creation pattern.
abstract class BaseBlocPage<B extends BlocBase<Object?>> extends StatelessWidget {
  const BaseBlocPage({super.key});

  B createBloc(BuildContext context);

  Widget buildPage(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<B>(
      create: createBloc,
      child: Builder(builder: buildPage),
    );
  }
}
