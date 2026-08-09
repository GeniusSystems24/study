import '../../../../core/result/result.dart';
import '../entities/notification_request.dart';

abstract interface class NotificationRepository {
  Future<Result<SentNotification>> send(NotificationRequest request);
}
