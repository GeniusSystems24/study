import '../../domain/repositories/order_repository.dart';
import '../errors/application_exception.dart';

final class GetOrderUseCase {
  const GetOrderUseCase({required this.orderRepository});

  final OrderRepository orderRepository;

  Future<Map<String, Object>> execute(String id) async {
    final order = await orderRepository.findById(id);
    if (order == null) {
      throw const ApplicationException(
        'ORDER_NOT_FOUND',
        'Order was not found.',
        status: 404,
      );
    }
    return order.toJson();
  }
}
