abstract class CounterRepository {
  Future<int> current();
  Future<int> increment();
}
