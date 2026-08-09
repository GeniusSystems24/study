import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';

final class InMemoryOrderRepository implements OrderRepository {
  InMemoryOrderRepository([Iterable<Order> initialOrders = const []])
      : _orders = {for (final order in initialOrders) order.id: order},
        _sequence = initialOrders.length;

  final Map<String, Order> _orders;
  int _sequence;

  @override
  Future<String> nextIdentity() async {
    _sequence += 1;
    return 'o-$_sequence';
  }

  @override
  Future<void> save(Order order) async {
    _orders[order.id] = order;
  }

  @override
  Future<Order?> findById(String id) async => _orders[id];
}
