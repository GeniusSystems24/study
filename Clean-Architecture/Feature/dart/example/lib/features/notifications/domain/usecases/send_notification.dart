import '../../../../core/error/failure.dart';
import '../../../../core/result/result.dart';
import '../entities/notification_request.dart';
import '../repositories/notification_repository.dart';

class SendNotification {
  const SendNotification(this._repository);
  final NotificationRepository _repository;

  Future<Result<SentNotification>> call(NotificationRequest request) {
    if (request.message.trim().length < 3) {
      return Future.value(const FailureResult(Failure('Message is too short')));
    }
    return _repository.send(request);
  }
}
