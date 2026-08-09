import '../entities/order.dart';

abstract interface class OrderRepository {
  Future<String> nextIdentity();
  Future<void> save(Order order);
  Future<Order?> findById(String id);
}
