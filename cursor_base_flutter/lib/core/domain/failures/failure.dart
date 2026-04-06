class Failure implements Exception {
  const Failure(this.message);

  final String message;

  @override
  String toString() => message;
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'Something went wrong. Try again.']);
}

