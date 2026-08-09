import 'package:dart_layered_clean_architecture_example/src/application/dto/create_order_request.dart';
import 'package:dart_layered_clean_architecture_example/src/application/usecases/create_order_use_case.dart';
import 'package:dart_layered_clean_architecture_example/src/domain/entities/user.dart';
import 'package:dart_layered_clean_architecture_example/src/domain/value_objects/email.dart';
import 'package:dart_layered_clean_architecture_example/src/infrastructure/repositories/in_memory_order_repository.dart';
import 'package:dart_layered_clean_architecture_example/src/infrastructure/repositories/in_memory_user_repository.dart';
import 'package:test/test.dart';

void main() {
  test('CreateOrderUseCase creates and persists an order', () async {
    final userRepository = InMemoryUserRepository([
      User(
        id: 'u-1',
        email: Email('anwar@example.com'),
        name: 'Anwar',
        passwordHash: 'hash',
      ),
    ]);
    final orderRepository = InMemoryOrderRepository();
    final useCase = CreateOrderUseCase(
      userRepository: userRepository,
      orderRepository: orderRepository,
      clock: () => DateTime.utc(2026),
    );

    final result = await useCase.execute(
      CreateOrderRequest(
        userId: 'u-1',
        currency: 'USD',
        items: const [
          CreateOrderItemRequest(
            productId: 'p-1',
            name: 'Keyboard',
            unitPrice: 80,
            quantity: 2,
          ),
        ],
      ),
    );

    expect((result['total'] as Map)['amount'], 160);
    expect(result['status'], 'CREATED');
    expect(await orderRepository.findById(result['id'] as String), isNotNull);
  });
}
