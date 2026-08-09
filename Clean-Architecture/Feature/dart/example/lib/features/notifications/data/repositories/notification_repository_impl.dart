import '../../../../core/error/failure.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/notification_request.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  const NotificationRepositoryImpl(this._remoteDataSource);
  final NotificationRemoteDataSource _remoteDataSource;

  @override
  Future<Result<SentNotification>> send(NotificationRequest request) async {
    try {
      return Success(await _remoteDataSource.send(request));
    } on ApiException catch (error) {
      return FailureResult(Failure(error.message, code: error.code));
    } catch (_) {
      return const FailureResult(Failure('Unable to send the notification'));
    }
  }
}
