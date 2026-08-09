import 'package:http/http.dart' as http;

import '../core/config/app_config.dart';
import '../core/network/api_client.dart';
import '../features/auth/data/datasources/auth_remote_data_source.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/usecases/login_user.dart';
import '../features/auth/presentation/controllers/auth_controller.dart';
import '../features/notifications/data/datasources/notification_remote_data_source.dart';
import '../features/notifications/data/repositories/notification_repository_impl.dart';
import '../features/notifications/domain/usecases/send_notification.dart';
import '../features/notifications/presentation/controllers/notification_controller.dart';

class AppDependencies {
  AppDependencies._({
    required this.authController,
    required this.notificationController,
    required http.Client httpClient,
  }) : _httpClient = httpClient;

  final AuthController authController;
  final NotificationController notificationController;
  final http.Client _httpClient;

  factory AppDependencies.create() {
    final httpClient = http.Client();
    final apiClient = ApiClient(baseUrl: AppConfig.apiBaseUrl, client: httpClient);

    final authDataSource = AuthRemoteDataSourceImpl(apiClient);
    final authRepository = AuthRepositoryImpl(authDataSource);
    final authController = AuthController(LoginUser(authRepository));

    final notificationDataSource = NotificationRemoteDataSourceImpl(apiClient);
    final notificationRepository = NotificationRepositoryImpl(notificationDataSource);
    final notificationController = NotificationController(
      SendNotification(notificationRepository),
    );

    return AppDependencies._(
      authController: authController,
      notificationController: notificationController,
      httpClient: httpClient,
    );
  }

  void dispose() {
    authController.dispose();
    notificationController.dispose();
    _httpClient.close();
  }
}
