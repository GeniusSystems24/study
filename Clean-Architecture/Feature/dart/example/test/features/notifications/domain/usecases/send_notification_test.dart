import 'package:clean_architecture_feature_based_flutter_example/core/result/result.dart';
import 'package:clean_architecture_feature_based_flutter_example/features/notifications/domain/entities/notification_request.dart';
import 'package:clean_architecture_feature_based_flutter_example/features/notifications/domain/repositories/notification_repository.dart';
import 'package:clean_architecture_feature_based_flutter_example/features/notifications/domain/usecases/send_notification.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeNotificationRepository implements NotificationRepository {
  NotificationRequest? captured;

  @override
  Future<Result<SentNotification>> send(NotificationRequest request) async {
    captured = request;
    return const Success(SentNotification(id: '1', channel: 'email', status: 'sent'));
  }
}

void main() {
  test('SendNotification sends valid requests through the contract', () async {
    final repository = FakeNotificationRepository();
    final useCase = SendNotification(repository);
    final result = await useCase(const NotificationRequest(
      channel: 'email',
      recipient: 'student@example.com',
      message: 'Welcome',
    ));

    expect(repository.captured?.recipient, 'student@example.com');
    expect(result, isA<Success<SentNotification>>());
  });
}
