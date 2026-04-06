import 'package:flutter_cursor_plugin_example/core/domain/failures/failure.dart';
import 'package:flutter_cursor_plugin_example/core/domain/failures/use_case_result.dart';

class NoParams {
  const NoParams();
}

abstract class BaseUseCase<Output, Params> {
  const BaseUseCase();

  Future<UseCaseResult<Output>> call(Params params) async {
    try {
      final output = await execute(params);
      return UseCaseResult.success(output);
    } on Failure catch (failure) {
      return UseCaseResult.failure(failure);
    } catch (_) {
      return const UseCaseResult.failure(UnexpectedFailure());
    }
  }

  Future<Output> execute(Params params);
}

