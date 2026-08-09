import '../application/usecases/create_order_use_case.dart';
import '../application/usecases/get_order_use_case.dart';
import '../application/usecases/login_use_case.dart';
import '../domain/entities/user.dart';
import '../domain/value_objects/email.dart';
import '../infrastructure/repositories/in_memory_order_repository.dart';
import '../infrastructure/repositories/in_memory_user_repository.dart';
import '../infrastructure/security/simple_password_hasher.dart';
import '../infrastructure/security/simple_token_service.dart';
import '../presentation/controllers/auth_controller.dart';
import '../presentation/controllers/order_controller.dart';

final class AppContainer {
  AppContainer._({
    required this.authController,
    required this.orderController,
  });

  final AuthController authController;
  final OrderController orderController;

  static Future<AppContainer> create() async {
    const passwordHasher = SimplePasswordHasher();
    final userRepository = InMemoryUserRepository([
      User(
        id: 'u-1',
        email: Email('anwar@example.com'),
        name: 'Anwar',
        passwordHash: await passwordHasher.hash('secret123'),
      ),
    ]);
    final orderRepository = InMemoryOrderRepository();
    final tokenService = SimpleTokenService(secret: 'development-secret');

    final loginUseCase = LoginUseCase(
      userRepository: userRepository,
      passwordHasher: passwordHasher,
      tokenService: tokenService,
    );
    final createOrderUseCase = CreateOrderUseCase(
      userRepository: userRepository,
      orderRepository: orderRepository,
    );
    final getOrderUseCase = GetOrderUseCase(
      orderRepository: orderRepository,
    );

    return AppContainer._(
      authController: AuthController(loginUseCase: loginUseCase),
      orderController: OrderController(
        createOrderUseCase: createOrderUseCase,
        getOrderUseCase: getOrderUseCase,
      ),
    );
  }
}
