import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/value_objects/money.dart';
import '../dto/create_order_request.dart';
import '../errors/application_exception.dart';

typedef Clock = DateTime Function();

final class CreateOrderUseCase {
  CreateOrderUseCase({
    required this.userRepository,
    required this.orderRepository,
    Clock? clock,
  }) : clock = clock ?? (() => DateTime.now().toUtc());

  final UserRepository userRepository;
  final OrderRepository orderRepository;
  final Clock clock;

  Future<Map<String, Object>> execute(CreateOrderRequest request) async {
    final user = await userRepository.findById(request.userId);
    if (user == null) {
      throw const ApplicationException(
        'USER_NOT_FOUND',
        'User was not found.',
        status: 404,
      );
    }
    user.assertCanLogin();

    final items = request.items
        .map(
          (item) => OrderItem(
            productId: item.productId,
            name: item.name,
            unitPrice: Money(item.unitPrice, request.currency),
            quantity: item.quantity,
          ),
        )
        .toList();

    final order = Order(
      id: await orderRepository.nextIdentity(),
      userId: user.id,
      items: items,
      createdAt: clock(),
    );

    await orderRepository.save(order);
    return order.toJson();
  }
}
